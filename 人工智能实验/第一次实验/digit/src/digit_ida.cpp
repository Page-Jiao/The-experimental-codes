#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <assert.h>
#include <vector>
#include <map>
#include <queue>
#include <stack>
#include <time.h>

using namespace std;

#define N 5
#define MAX_BOUND 1000
#define H_NUM 1

struct NODE
{
    unsigned char     map[N * N];         // 数码图
    float             g;                  // 与起点距离
    float             h;                  // 与终点距离
    unsigned char     zeros[2];           // 要移动的0点的坐标
    NODE*             parent = NULL;      // 父节点
    unsigned char     direct;
    unsigned char     zeroNum;

    float f() const
    {
        return g + h;
    }

    bool operator<(const NODE &x) const
    {
        return g + h > x.g + x.h;
    }

    // bool operator == (const NODE &rhs);

    //  bool operator != (const NODE &rhs);
};


// bool NODE::operator == (const NODE &rhs)

// {

//     return map[N * N] == rhs.map[N * N];

// }

// bool NODE::operator != (const NODE &rhs)

// {
//     return map[N * N] != rhs.map[N * N];
//     // return uc2str(map) != uc2str(rhs.map);

// }

NODE End;
NODE Start;
string path;
int pathLen = 0;
float ids_dfs(NODE head, map<string, bool> &mapDup, float g, float bound);
/*
    00 01 02 03 04 
    05 06 07 08 09
    10 11 12 13 14 
    15 16 17 18 19 
    20 21 07 07 00
*/
unsigned char EndLoc[25][2] = {
    {4, 3}, {0, 0}, {0, 1}, {0, 2}, {0, 3},
    {0, 4}, {2, 0}, {1, 0}, {1, 2}, {1, 3}, 
    {1, 4}, {2, 2}, {2, 3}, {2, 4}, {3, 0},
    {3, 1}, {3, 2}, {3, 3}, {3, 4}, {4, 0},
    {4, 1}, {4, 2}, {2, 1}, {3, 2}, {4, 4}
};
unsigned char hMap[N * N] =
{
    23,  0,  1,  2,  3,
    4,  10,  5,  7,  8,
    9,  12,  13, 14, 15,
    16, 17,  18, 19, 20,
    21, 22,  0,  0,  0
};

void split(const string& s, vector<int>& sv, const char flag = ' ') {//？？？
    sv.clear();
    istringstream iss(s);
    string temp;

    while (getline(iss, temp, flag)) {
        sv.push_back(stoi(temp));
    }
    return;
}

string uc2str(unsigned char map[N * N])//map变string
{
    string str(N * N, '\0');
    for (int i = 0; i < N * N; i++)
        str[i] = map[i];
    return str;
}

bool node_map_equal(NODE nodeA, NODE nodeB)
{
    for (int i = 0; i < N * N; i++)
    {
        if (nodeA.map[i] != nodeB.map[i])
            return false;
    }
    return true;
}

void show_node(NODE *node)
{
    printf("Digital map of node:\n");
    for (int i=0; i<5; i++)
    {
        printf("%-4d", node->map[i*N+0]);
        printf("%-4d", node->map[i*N+1]);
        printf("%-4d", node->map[i*N+2]);
        printf("%-4d", node->map[i*N+3]);
        printf("%-4d\n", node->map[i*N+4]);
    }
    printf("Direct of node: %d\n", node->direct);
    printf("Zero loc of node: [%d], [%d]\n", node->zeros[0], node->zeros[1]);
    printf("G, H, F of node: %.1f, %.1f, %.1f\n", node->g, node->h, node->f());
}

void print_single_path(NODE *node, string &path)
{
    map<unsigned char, char> mapDirect;
    mapDirect[1] = 'd';
    mapDirect[2] = 'u';
    mapDirect[3] = 'r';
    mapDirect[4] = 'l';
    if (node->zeroNum == 2)               // 7块移动
    {
        printf("(7, %c)", mapDirect[node->direct]);
        path = path + "(7, " + mapDirect[node->direct] + ");";
    }
    else
    {
        int loc = node->zeros[node->zeroNum];
        unsigned char d = node->direct;
        loc = (d == 1) ? (loc + 5) : (d == 2) ? (loc - 5) : (d == 3) ? (loc + 1) : (loc - 1);
        int number = node->map[loc];
        assert(number != 7);
        printf("(%d, %c)", number, mapDirect[d]);
        path = path + "(" + to_string(number) + ", " + mapDirect[node->direct] + ");";
    }
}

void print_path(NODE *node, int *pathLen, string &path)
{
    NODE *p = node->parent;
    if (p->parent != NULL)
    {
        print_path(p, pathLen, path);
    }
    // show_node(node);
    print_single_path(node, path);
    *pathLen += 1;
}

void save_result(string path)
{
    ofstream out;
    out.open("..\\output\\path.txt");
    out << path << endl;
    out.close();
}

float calculate_h(unsigned char map[N * N])//实现估计函数一样，表示不一样
{
    int sum = 0;
    int x, y;
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            if(map[i * N + j] == 0)
                continue;
            x = hMap[map[i * N + j]] / N;
            y = hMap[map[i * N + j]] % N;
            sum += abs(x - i) + abs(y - j);
        }
    }
    return sum;
}

float calculate_h_2(unsigned char map[N * N])
{
    int sum = 0;
    int x, y;
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
        {
            unsigned char num = map[i * N + j];
            if(num == 0 || num == 7)
                continue;
            x = EndLoc[num][0];
            y = EndLoc[num][1];
            sum += abs(x - i) + abs(y - j);
        }
    }
    return sum;
}

void init_end_map(NODE *End)
{
    End->map[0*N+0]=1;  End->map[0*N+1]=2;  End->map[0*N+2]=3;  End->map[0*N+3]=4;  End->map[0*N+4]=5; 
    End->map[1*N+0]=7;  End->map[1*N+1]=7;  End->map[1*N+2]=8;  End->map[1*N+3]=9;  End->map[1*N+4]=10; 
    End->map[2*N+0]=6;  End->map[2*N+1]=7;  End->map[2*N+2]=11; End->map[2*N+3]=12; End->map[2*N+4]=13; 
    End->map[3*N+0]=14; End->map[3*N+1]=15; End->map[3*N+2]=16; End->map[3*N+3]=17; End->map[3*N+4]=18; 
    End->map[4*N+0]=19; End->map[4*N+1]=20; End->map[4*N+2]=21; End->map[4*N+3]=0;  End->map[4*N+4]=0; 
}

void init_start_map(NODE *Start, string num)//读文件初始化
{
    ifstream inFile;
    num.append(".txt");
    inFile.open(num);
    if (!inFile) { 
        cout << "error opening data file." << endl;
        return ;
    }
    string temp;
    vector<int> sv;
    int row = 0;
    while (!inFile.eof())
    {
        int column = 0;
        inFile >> temp;
        split(temp, sv, ',');
        for (const auto& s : sv) {
            Start->map[row*N+column] = s;
            column += 1;
        }
        assert(column == N);
        row += 1;
    }
    assert(row == N);
    int zeroCnt = 0;
    for (int i = 0; i < N * N; i++)
    {
        if (Start->map[i] == 0)
        {
            Start->zeros[zeroCnt] = i;
            zeroCnt += 1;
        }
    }
    assert(zeroCnt == 2);
    Start->g = 0.0;
    if (H_NUM == 1)
        Start->h = calculate_h(Start->map);
    if (H_NUM == 2)
        Start->h = calculate_h_2(Start->map);
}

char get_value_beside(unsigned char map[N * N], int direct, int zeroLoc)
{
    // (u:1 / d:2 / l:3 / r:4)
    if (direct == 1)
    {
        if (zeroLoc <= 4)
            return -1;
        return map[zeroLoc - 5];
    }
    else if (direct == 2)
    {
        if (zeroLoc >= 20)
            return -1;
        return map[zeroLoc + 5];
    }
    else if (direct == 3)
    {
        if (zeroLoc % 5 == 0)
            return -1;
        return map[zeroLoc - 1];
    }
    else if (direct == 4)
    {
        if (zeroLoc % 5 == 4)
            return -1;
        return map[zeroLoc + 1];
    }
    return -1;
}

int check_move_seven(NODE *node)
{
    int sevenLoc = 0;
    for (int i = 0; i < N * N; i++)
    {
        if (node->map[i] == 7)
        {
            sevenLoc = i;
            break;
        }
    }

    int zeroLocA = node->zeros[0];
    int zeroLocB = node->zeros[1];
    if ((zeroLocA == sevenLoc + 5 && zeroLocB == zeroLocA + 6) 
        || (zeroLocB == sevenLoc + 5 && zeroLocA == zeroLocB + 6))
        return 1;   // 0上移
    if ((zeroLocA == sevenLoc - 5 && zeroLocB == zeroLocA + 1) 
        || (zeroLocB == sevenLoc - 5 && zeroLocA == zeroLocB + 1))
        return 2;   // 0下移
    if ((zeroLocA == sevenLoc + 2 && zeroLocB == zeroLocA + 5 && sevenLoc % N != 3) 
        || (zeroLocB == sevenLoc + 2 && zeroLocA == zeroLocB + 5 && sevenLoc % N != 3))
        return 3;   // 0左移
    if ((zeroLocA == sevenLoc - 1 && zeroLocB == zeroLocA + 6 && sevenLoc % N != 0) 
        || (zeroLocB == sevenLoc - 1 && zeroLocA == zeroLocB + 6 && sevenLoc % N != 0))
        return 4;   // 0右移
    return 0;
}

/* 
    | 00 | 01 | 02 | 03 | 04 |
    | 05 | 06 | 07 | 08 | 09 |
    | 10 | 11 | 12 | 13 | 14 |
    | 15 | 16 | 17 | 18 | 19 |
    | 20 | 21 | 22 | 23 | 24 |
*/
void move_zero(NODE &node, int direct, int zeroNum, char adjValue)
{
    int zeroLoc = node.zeros[zeroNum];
    if (direct == 1)           // 0上移
    {
        node.map[zeroLoc] = adjValue;
        node.map[zeroLoc - 5] = 0;
        node.zeros[zeroNum] = zeroLoc - 5;
    }
    else if (direct == 2)      // 0下移
    {
        node.map[zeroLoc] = adjValue;
        node.map[zeroLoc + 5] = 0;
        node.zeros[zeroNum] = zeroLoc + 5;
    }
    else if (direct == 3)      // 0左移
    {
        node.map[zeroLoc] = adjValue;
        node.map[zeroLoc - 1] = 0;
        node.zeros[zeroNum] = zeroLoc - 1;
    }
    else if (direct == 4)      // 0右移
    {
        node.map[zeroLoc] = adjValue;
        node.map[zeroLoc + 1] = 0;
        node.zeros[zeroNum] = zeroLoc + 1;
    }
}

void move_seven(NODE &node, int direct)
{
    int sevenLoc = 0;
    for (int i = 0; i < N * N; i++)
    {
        if (node.map[i] == 7)
        {
            sevenLoc = i;
            break;
        }
    }

    if (direct == 1)           // 0上移
    {
        node.map[sevenLoc + 5] = 7;
        node.map[sevenLoc + 11] = 7;
        node.map[sevenLoc] = 0;
        node.map[sevenLoc + 1] = 0;
        node.zeros[0] = sevenLoc;
        node.zeros[1] = sevenLoc + 1;
    }
    else if (direct == 2)      // 0下移
    {
        node.map[sevenLoc - 5] = 7;
        node.map[sevenLoc - 4] = 7;
        node.map[sevenLoc] = 0;
        node.map[sevenLoc + 6] = 0;
        node.zeros[0] = sevenLoc;
        node.zeros[1] = sevenLoc + 6;
    }
    else if (direct == 3)      // 0左移
    {
        node.map[sevenLoc + 2] = 7;
        node.map[sevenLoc + 7] = 7;
        node.map[sevenLoc] = 0;
        node.map[sevenLoc + 6] = 0;
        node.zeros[0] = sevenLoc;
        node.zeros[1] = sevenLoc + 6;
    }
    else if (direct == 4)      // 0右移
    {
        node.map[sevenLoc - 1] = 7;
        node.map[sevenLoc + 5] = 7;
        node.map[sevenLoc + 1] = 0;
        node.map[sevenLoc + 6] = 0;
        node.zeros[0] = sevenLoc + 1;
        node.zeros[1] = sevenLoc + 6;
    }
}

NODE get_successor(NODE * minNode,map<string, bool> &mapDup)
{
    NODE nextNode;
    for (int i = 1; i <= 4; i++)
    {
        char adjValue = get_value_beside(minNode->map, i, minNode->zeros[0]);
        if (adjValue <= 0 || adjValue == 7)
            continue;

        nextNode = *minNode;
        move_zero(nextNode, i, 0, adjValue);
        string nextStr = uc2str(nextNode.map);
        if (mapDup.count(nextStr) == 0)
        {
            nextNode.parent = minNode;
            nextNode.zeroNum = 0;
            nextNode.direct = i;
            mapDup[nextStr] = true;
            nextNode.g++;
            if (H_NUM == 1)
                nextNode.h = calculate_h(nextNode.map);
            if (H_NUM == 2)
                nextNode.h = calculate_h_2(nextNode.map);
            // list.push(nextNode);
            return nextNode;
        }
        // nextNode.parent = minNode;
        // nextNode.zeroNum = 0;
        // nextNode.direct = i;
        // //mapDup[nextStr] = true;
        // nextNode.g++;
        // if (H_NUM == 1)
        //     nextNode.h = calculate_h(nextNode.map);
        // if (H_NUM == 2)
        //     nextNode.h = calculate_h_2(nextNode.map);
        // list.push_back(nextNode);
    }

    // cout << "  cdd3.1\n";
    for (int i = 1; i <= 4; i++)
    {
        char adjValue = get_value_beside(minNode->map, i, minNode->zeros[1]);
        if (adjValue <= 0 || adjValue == 7)
            continue;

        nextNode = *minNode;
        move_zero(nextNode, i, 1, adjValue);
        string nextStr = uc2str(nextNode.map);
        if (mapDup.count(nextStr) == 0)
        {
            nextNode.parent = minNode;
            nextNode.zeroNum = 1;
            nextNode.direct = i;
            mapDup[nextStr] = true;
            nextNode.g++;
            if (H_NUM == 1)
                nextNode.h = calculate_h(nextNode.map);
            if (H_NUM == 2)
                nextNode.h = calculate_h_2(nextNode.map);
            // list.push(nextNode);
             return nextNode;
        }
        // nextNode.parent = minNode;
        // nextNode.zeroNum = 1;
        // nextNode.direct = i;
        // //mapDup[nextStr] = true;
        // nextNode.g++;
        // if (H_NUM == 1)
        //     nextNode.h = calculate_h(nextNode.map);
        // if (H_NUM == 2)
        //     nextNode.h = calculate_h_2(nextNode.map);
        // list.push_back(nextNode);
    }//for (int i = 1; i <= 4; i++)
    // cout << "  cdd3.2\n";
    int sevenDirect = check_move_seven(minNode);
    if (sevenDirect > 0)
    {
        nextNode = *minNode;
        move_seven(nextNode, sevenDirect);
        string nextStr = uc2str(nextNode.map);
        if (mapDup.count(nextStr) == 0)
        {
            nextNode.parent = minNode;
            nextNode.zeroNum = 2;
            nextNode.direct = sevenDirect;
            mapDup[nextStr] = true;
            nextNode.g++;
            if (H_NUM == 1)
                nextNode.h = calculate_h(nextNode.map);
            if (H_NUM == 2)
                nextNode.h = calculate_h_2(nextNode.map);
            // list.push(nextNode);
             return nextNode;
        }
        // nextNode.parent = minNode;
        // nextNode.zeroNum = 2;
        // nextNode.direct = sevenDirect;
        // //mapDup[nextStr] = true;
        // nextNode.g++;
        // if (H_NUM == 1)
        //     nextNode.h = calculate_h(nextNode.map);
        // if (H_NUM == 2)
        //     nextNode.h = calculate_h_2(nextNode.map);
        // list.push_back(nextNode);
    }//if (sevenDirect > 0)
    // cout << "  cdd3.3\n";
    return *minNode;
}
float ids_dfs(NODE head, map<string, bool> &mapDup, float g, float bound)
{
    NODE nextNode;
    float dMin = 99999;
    float f;
    if (H_NUM == 1)
        f = g + calculate_h(head.map);
    if (H_NUM == 2)
        f = g + calculate_h_2(head.map);
    if (f > bound)
    {
        return f;
    }
    if(node_map_equal(head, End))
    {
        // nextNode.g++;
        print_path(&head, &pathLen, path);
        return -1;
    }
    float f1;
    nextNode = get_successor(&head,mapDup);
    while (uc2str(nextNode.map) != uc2str(head.map))
    {
        f1 = ids_dfs(nextNode,mapDup,g+1,bound);
        // cout << "    cdd4 "<<f1<< "  "<< "  "<<g<< "  "<< bound<<"\n";
        if(f1 == -1)
            return -1;
        else
        {
            if(f1<dMin)
                dMin = f1;
        }
        nextNode = get_successor(&head,mapDup);
    }
    return dMin;
}

bool ida_star(string num)
{
    //stack<NODE> Open;
    NODE nextNode;
    map<string, bool> mapDup;
    //int pathLen = 1;

    init_end_map(&End);
    init_start_map(&Start, num);
    float bound;
    if (H_NUM == 1)
        bound = calculate_h(Start.map);
    if (H_NUM == 2)
        bound = calculate_h_2(Start.map);
    float dLim = bound;
    while (true)
    {
        mapDup.clear();
        mapDup[uc2str(Start.map)] = true;
        dLim = ids_dfs(Start, mapDup, 0, bound);
        if (dLim == -1)//成功
        {
            return true;
        }
        if (dLim > MAX_BOUND)
        {
            cout << "Out of MAX_BOUND !" << endl;
            return false;
        }
        bound = dLim;//加大阈值
    }
}

int main(int argc, char *argv[])
{
    string num;
    num = "..\\input\\";
    num  += argv[1][0];
    clock_t clkStart, clkEnd;
    string outfile;
    outfile = "..\\output\\";
    outfile += argv[1][0];
    outfile.append(".txt");
    ofstream out;
    //cout << "cdd\n";
    clkStart = clock();
    if(ida_star(num))
    {
        cout << endl << "Path length = " << pathLen << endl;
        out.open(outfile);
        out << path << endl;
        out.close();
    }
    else
    {
        cout << "fail" << endl;
    }
    
    clkEnd = clock();
    double endtime = (double)(clkEnd - clkStart) / CLOCKS_PER_SEC;
    cout << "Total time:" << endtime << endl;
}