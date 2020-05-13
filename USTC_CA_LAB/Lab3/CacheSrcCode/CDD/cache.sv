//`define LRU 1'b0
//`define FIFO 1'b1
//宏定义是否会影响下面的命名？
module cache #(
    parameter  LINE_ADDR_LEN = 3, // line内地址长度，决定了每个line具有2^3个word
    parameter  SET_ADDR_LEN  = 3, // 组地址长度，决定了一共有2^3=8组
    parameter  TAG_ADDR_LEN  = 6, // tag长度
    parameter  WAY_CNT       = 4,  // 组相连度，决定了每组中有多少路line
    parameter LRU = 1'b0,
    parameter FIFO = 1'b1
)(
    input  clk, rst,
    output miss,               // 对CPU发出的miss信号
    input  [31:0] addr,        // 读写请求地址
    input  rd_req,             // 读请求信号
    output reg [31:0] rd_data, // 读出的数据，一次读一个word
    input  wr_req,             // 写请求信号
    input  [31:0] wr_data      // 要写入的数据，一次写一个word
);

reg [31:0] hit_count, miss_count;
always@(*)
begin
    if(rst)
    begin
        hit_count <= 32'b0;
        miss_count <= 32'b0;
    end
end

localparam MEM_ADDR_LEN    = TAG_ADDR_LEN + SET_ADDR_LEN ; // 计算主存地址长度 MEM_ADDR_LEN，主存大小=2^MEM_ADDR_LEN个line
localparam UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ;       // 计算未使用的地址的长度

localparam LINE_SIZE       = 1 << LINE_ADDR_LEN  ;         // 计算 line 中 word 的数量，即 2^LINE_ADDR_LEN 个word 每 line
localparam SET_SIZE        = 1 << SET_ADDR_LEN   ;         // 计算一共有多少组，即 2^SET_ADDR_LEN 个组

reg [            31:0] cache_mem    [SET_SIZE][WAY_CNT][LINE_SIZE]; // SET_SIZE个WAY，每个WAY有WAY_CNT个line,每个line有LINE_SIZE个word
reg [TAG_ADDR_LEN-1:0] cache_tags   [SET_SIZE][WAY_CNT];            // SET_SIZE个TAG
reg                    valid        [SET_SIZE][WAY_CNT];            // SET_SIZE个valid(有效位)
reg                    dirty        [SET_SIZE][WAY_CNT];            // SET_SIZE个dirty(脏位)

wire [              2-1:0]   word_addr;                   // 将输入地址addr拆分成这5个部分
wire [  LINE_ADDR_LEN-1:0]   line_addr;
wire [   SET_ADDR_LEN-1:0]    set_addr;
wire [   TAG_ADDR_LEN-1:0]    tag_addr;
wire [UNUSED_ADDR_LEN-1:0] unused_addr;

enum  {IDLE, SWAP_OUT, SWAP_IN, SWAP_IN_OK} cache_stat;    // cache 状态机的状态定义
                                                           // IDLE代表就绪，SWAP_OUT代表正在换出，SWAP_IN代表正在换入，SWAP_IN_OK代表换入后进行一周期的写入cache操作。

reg  [   SET_ADDR_LEN-1:0] mem_rd_set_addr = 0;
reg  [   TAG_ADDR_LEN-1:0] mem_rd_tag_addr = 0;
wire [   MEM_ADDR_LEN-1:0] mem_rd_addr = {mem_rd_tag_addr, mem_rd_set_addr};
reg  [   MEM_ADDR_LEN-1:0] mem_wr_addr = 0;

reg  [31:0] mem_wr_line [LINE_SIZE];
wire [31:0] mem_rd_line [LINE_SIZE];

wire mem_gnt;      // 主存响应读写的握手信号
reg [31:0] line_index;   //确定选择哪一个line
reg [31:0] selected_index; //选择确认
reg [31:0] LRU_TABLE [SET_SIZE][WAY_CNT];
reg [31:0] FIFO_TABLE [SET_SIZE][WAY_CNT];//用于LRU和FIFO的历史信息表
reg algorithm_select = 1'b1;   //决定选择什么算法
reg alter;              //修改信号


integer i, j;
always@ (posedge clk or negedge rst)
begin
    if(rst) //重置
    begin
        for(i=0;i<SET_SIZE;i++)
        begin
            for(j=0;j<WAY_CNT;j++)
            begin
                FIFO_TABLE[i][j] = 32'b0;
                LRU_TABLE [i][j] = 32'b0;
            end
        end
    end
    else begin //否则需要根据具体情况更新TABLE
        if(algorithm_select == LRU)
        begin
            if (alter)  //如果修改，则有可能更新值
            begin
                for ( i = 0; i < WAY_CNT; i++)
                begin 
                    if (i == line_index)    //操作了，说明使用了，重置
                    begin
                        LRU_TABLE[set_addr][i] = 32'b0;
                    end
                    else                    //否则没使用，自增
                    begin
                        LRU_TABLE[set_addr][i]++;
                    end
                end
            end
        end
        else if(algorithm_select == FIFO)   //使用FIFO算法,依据换入顺序更新
        begin
            if(cache_stat == SWAP_IN_OK) //正在写
            begin
                for(i = 0; i < WAY_CNT; i++)
                begin
                    if(i == line_index)
                    FIFO_TABLE[set_addr][i] = 32'b0;
                    //换入，移至队列头。不可以用++！这样在下一次换入的时候其它++而自己不＋，顺序错误！
                    else
                    FIFO_TABLE[set_addr][i]++;
                end
            end
        end
    end
end

reg cache_hit = 1'b0;
reg [31:0]temp1, temp2;           //临时指示哪个表中要换的块

always @ (*)
begin
    cache_hit = 1'b0;
    line_index = 32'b0; //是否有必要归零？
    for( i = 0; i < WAY_CNT; i++)
    begin
       if(valid[set_addr][i] && cache_tags[set_addr][i] == tag_addr)   // 如果 cache line有效，并且tag与输入地址中的tag相等，则命中
       begin 
            cache_hit = 1'b1;
            line_index = i; //保存line地址的编号
        end
        // else begin 
        //     temp1 = 32'b0;
        //     temp2 = 32'b0;
        // end
    end
    if( i == WAY_CNT && cache_hit == 1'b0)  //遍历完成没有命中，需要选择替换的块
    begin
    temp1 = line_index;
    temp2 = line_index;
    for( i = 0; i< WAY_CNT; ++i)
    begin 
        if(LRU_TABLE[set_addr][temp1] < LRU_TABLE[set_addr][i]) 
        temp1 = i;
        if(FIFO_TABLE[set_addr][temp2] < FIFO_TABLE[set_addr][i]) 
        temp2 = i;
    end
    if(algorithm_select == LRU) line_index = temp1;
    else if(algorithm_select == FIFO) line_index = temp2;   //根据算法确定选择哪一个
    end
end

//为了避免读写信号持续多个周期时对LRU和FIFO表多次重复的过度更新，需要将之整合为只持续一个周期的信号，使用状态机实现
reg alter_before;
always @ (posedge clk or posedge rst) 
begin
    if (rst)
    begin
        alter <= 1'b0;
        alter_before <= 1'b0;
    end
    else 
    begin
        if (rd_req | wr_req) 
        begin
            if (alter_before == 1'b0 && alter == 1'b0) 
            begin
                alter_before <= 1'b1;
                alter <= 1'b1;
            end
            else if (alter_before == 1'b1 && alter == 1'b1)
            begin
                alter_before <= 1'b1;
                alter <= 1'b0;
            end
        end
        else 
        begin
            alter <= 1'b0;
            alter_before <= 1'b0;
        end
    end
end
assign {unused_addr, tag_addr, set_addr, line_addr, word_addr} = addr;  // 拆分 32bit ADDR


// always @ (*) begin              // 判断 输入的address 是否在 cache 中命中
//     if(valid[set_addr] && cache_tags[set_addr] == tag_addr)   // 如果 cache line有效，并且tag与输入地址中的tag相等，则命中
//         cache_hit = 1'b1;
//     else
//         cache_hit = 1'b0;
// end

//下面模块中用j指代way
always @ (posedge clk or posedge rst) begin     // ?? cache ???
    if(rst) begin
        cache_stat <= IDLE;
        for(integer i = 0; i < SET_SIZE; i++) begin
            for(integer j = 0; j < WAY_CNT; j++) begin
            dirty[i][j] = 1'b0;
            valid[i][j] = 1'b0;
            end
        end
        for(integer k = 0; k < LINE_SIZE; k++)
            mem_wr_line[k] <= 0;
        mem_wr_addr <= 0;
        {mem_rd_tag_addr, mem_rd_set_addr} <= 0;
        rd_data <= 0;
    end else begin
        case(cache_stat)
        IDLE:       begin
                        if(cache_hit) begin
                            hit_count++;
                            if(rd_req) begin    // 如果cache命中，并且是读请求，
                                rd_data <= cache_mem[set_addr][line_index][line_addr];   //则直接从cache中取出要读的数据
                            end else if(wr_req) begin // 如果cache命中，并且是写请求，
                                cache_mem[set_addr][line_index][line_addr] <= wr_data;   // 则直接向cache中写入数据
                                dirty[set_addr][line_index] <= 1'b1;                     // 写数据的同时置脏位
                            end 
                        end else begin
                            miss_count++;
                            if(wr_req | rd_req) begin   // 如果 cache 未命中，并且有读写请求，则需要进行换入
                                if(valid[set_addr][line_index] & dirty[set_addr][line_index]) begin    // 如果 要换入的cache line 本来有效，且脏，则需要先将它换出
                                    cache_stat  <= SWAP_OUT;
                                    mem_wr_addr <= {cache_tags[set_addr][line_index], set_addr};
                                    mem_wr_line <= cache_mem[set_addr][line_index];
                                end else begin                                   // 反之，不需要换出，直接换入
                                    cache_stat  <= SWAP_IN;
                                end
                                {mem_rd_tag_addr, mem_rd_set_addr} <= {tag_addr, set_addr};
                            end
                        end
                    end
        SWAP_OUT:   begin
                        if(mem_gnt) begin           // 如果主存握手信号有效，说明换出成功，跳到下一状态
                            cache_stat <= SWAP_IN;
                        end
                    end
        SWAP_IN:    begin
                        if(mem_gnt) begin           // 如果主存握手信号有效，说明换入成功，跳到下一状态
                            cache_stat <= SWAP_IN_OK;
                        end
                    end
        SWAP_IN_OK: begin           // 上一个周期换入成功，这周期将主存读出的line写入cache，并更新tag，置高valid，置低dirty
                        for(integer i=0; i<LINE_SIZE; i++)  cache_mem[mem_rd_set_addr][line_index][i] <= mem_rd_line[i];
                        cache_tags[mem_rd_set_addr][line_index] <= mem_rd_tag_addr;
                        valid     [mem_rd_set_addr][line_index] <= 1'b1;
                        dirty     [mem_rd_set_addr][line_index] <= 1'b0;
                        cache_stat <= IDLE;        // 回到就绪状态
                    end
        endcase
    end
end

wire mem_rd_req = (cache_stat == SWAP_IN );
wire mem_wr_req = (cache_stat == SWAP_OUT);
wire [   MEM_ADDR_LEN-1 :0] mem_addr = mem_rd_req ? mem_rd_addr : ( mem_wr_req ? mem_wr_addr : 0);

assign miss = (rd_req | wr_req) & ~(cache_hit && cache_stat==IDLE) ;     // 当 有读写请求时，如果cache不处于就绪(IDLE)状态，或者未命中，则miss=1

main_mem #(     // 主存，每次读写以line 为单位
    .LINE_ADDR_LEN  ( LINE_ADDR_LEN          ),
    .ADDR_LEN       ( MEM_ADDR_LEN           )
) main_mem_instance (
    .clk            ( clk                    ),
    .rst            ( rst                    ),
    .gnt            ( mem_gnt                ),
    .addr           ( mem_addr               ),
    .rd_req         ( mem_rd_req             ),
    .rd_line        ( mem_rd_line            ),
    .wr_req         ( mem_wr_req             ),
    .wr_line        ( mem_wr_line            )
);

endmodule




