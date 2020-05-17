#include <iostream>
#include <fstream>
#include <sstream>
#include <assert.h>
#include <string>
#include <cmath>
#include <vector>
#include <queue>
#include <map>
#include<algorithm>
#include <time.h>

using namespace std;
typedef int Sudoku[9][9];
Sudoku p;
int sum = 0;

struct position
{
    int x,y;
    int remain_value_num;
    map<int, bool> remain_value;
    bool operator<(const position &x) const
    {
        return remain_value_num  > x.remain_value_num;
    }
};

vector<position> list;

bool cmp(position x,position y) ///cmp函数传参的类型不是vector<int>型，是vector中元素类型,即int型
{
    return x.remain_value_num>y.remain_value_num;
}

void init_origin_sudoku(string name)// 读取文件建立初始的状态
{
    ifstream inFile;
    name.append(".txt");
    inFile.open(name);
    if (!inFile) { 
        cout << "error opening data file." << endl;
        return ;
    }
    int temp;
    int cnt = 0;
    while (!inFile.eof())
    {
        inFile >> temp;
        p[cnt / 9][cnt % 9] = temp;
        // cout << cnt << temp << endl;
        cnt += 1;
    }
    assert(cnt == 82);
}

void write_result(string name)
{
    ofstream out;
    name.append(".txt");
    out.open(name);
    string result;
    for (int i=0; i<9; i++)
    {
        result += (to_string(p[i][0]) + " " + to_string(p[i][1]) + " " 
        + to_string(p[i][2]) + " " + to_string(p[i][3]) + " " + to_string(p[i][4]) + " " 
        + to_string(p[i][5]) + " " + to_string(p[i][6]) + " " + to_string(p[i][7]) + " " 
        + to_string(p[i][8]) + "\n");
    }
    out << result;
    out.close();
}

void show_sudoku_puzzle(Sudoku puzzle)// 调试采用的输出函数
{
    printf("Value of sudoku puzzle:\n");
    for (int i=0; i<9; i++)
    {
        printf("%-4d", puzzle[i][0]);
        printf("%-4d", puzzle[i][1]);
        printf("%-2d| ", puzzle[i][2]);
        printf("%-4d", puzzle[i][3]);
        printf("%-4d", puzzle[i][4]);
        printf("%-2d| ", puzzle[i][5]);
        printf("%-4d", puzzle[i][6]);
        printf("%-4d", puzzle[i][7]);
        printf("%-4d\n", puzzle[i][8]);
        if ((i+1) % 3 == 0 && i != 8)
        {
            printf("---------------------------------\n");
        }
    }
}

bool IsValid(int i,int j, int t)
{
    int k;
    for(k=0;k<9;k++){
        if(j!=k && t==p[i][k] || i!=k && t==p[k][j])
            return false;
    }

    int iGrid=(i/3)*3;
    int jGrid=(j/3)*3;
    int k1,k2;
    for(k1=iGrid;k1<iGrid+3;k1++){
        for(k2=jGrid;k2<jGrid+3;k2++){
            if(t==p[k1][k2] && (k1 != iGrid || k2 != jGrid))
                return false;
        }
    }
    if(i == j)
    {
        for(k=0;k<9;k++)
        {
            if(t == p[k][k] && i != k)
                return false;
            
        }
    }
    if(i + j == 8)
    {
        for(k=0;k<9;k++)
        {
            if(t == p[k][8-k] && i != k)
                return false;
        }
    }
    return true;
}

void compute_remain_value(position * m)// 计算当前节点的剩余值
{
    int i;
    int num = 0;
    m->remain_value.clear();
    for(i = 1; i <= 9; i++)
    {
        if(IsValid(m->x,m->y,i))
        {
            m->remain_value[i] = true;
            num += 1;
        }
        else
        {
            m->remain_value[i] = false;
        }
        
    }
    m->remain_value_num = num;
}
void build_queue()// 建立初始的剩余值列表
{
    int i,j;
    position temp;
    for(i = 0; i < 9; i++)
    {
        for(j = 0; j < 9; j++)
        {
            if(p[i][j] == 0)
            {
                temp.x = i;
                temp.y = j;
                //cout << i << j << endl;
                compute_remain_value(&temp);
                list.push_back(temp);
            }
        }
    }
    sort(list.begin(),list.end(),cmp);
}

void refresh_remain_value_minus() // 以减量的形式刷新剩余值列表
{
    position temp;
    for(int i=0;i<list.size();i++)
    {
        temp = list[i];
        for(int j=1;j<=9;j++)
        {
            if(temp.remain_value[j] && !IsValid(temp.x,temp.y,j))
            {
                list[i].remain_value[j] = false;
                list[i].remain_value_num -= 1;
            }
        }
    }
}

void refresh_remain_value_all() // 考虑刷新全部剩余值
{
    position temp;
    int num = 0;
    for(int i=0;i<list.size();i++)
    {
        temp = list[i];
        num = 0;
        for(int j=1;j<=9;j++)
        {
            if(IsValid(temp.x,temp.y,j))
            {
                list[i].remain_value[j] = true;
                num += 1;
            }
            else
            {
                list[i].remain_value[j] = false;
            }
                
        }
        list[i].remain_value_num = num;
    }
}

void select_min_domain(position &d) // 选择列表中拥有最小剩余值个数的项
{
    int min_value_num = 10;
    auto min = list.begin();
    for (auto it = list.begin(); it != list.end(); it++)
    {
        if((*it).remain_value_num <= min_value_num)
        {
            min_value_num = (*it).remain_value_num;
            min = it;
        }
    }
    d.x = (*min).x;
    d.y = (*min).y;
    d.remain_value_num = (*min).remain_value_num;
    d.remain_value = (*min).remain_value;
    list.erase(min);
}

void select_min_domain_without_delete(position &d) // 选择列表中拥有最小剩余值个数的项但不删除最小项
{
    int min_value_num = 10;
    auto min = list.begin();
    for (auto it = list.begin(); it != list.end(); it++)
    {
        if((*it).remain_value_num <= min_value_num)
        {
            min_value_num = (*it).remain_value_num;
            min = it;
        }
    }
    d.x = (*min).x;
    d.y = (*min).y;
    d.remain_value_num = (*min).remain_value_num;
    d.remain_value = (*min).remain_value;
}

bool R_Sudoku()
{
    int i;
    sum +=1;
    position temp;
    position max;
    if(list.size()==0)
        return true;
    select_min_domain(temp);
    for(i=1;i<=9;i++)
    {
        if(temp.remain_value[i])
        {
            p[temp.x][temp.y] = i;
            refresh_remain_value_minus();
            select_min_domain_without_delete(max);
            if(max.remain_value_num == 0)
            {
                p[temp.x][temp.y] = 0;
                //list.push_back(temp);
                refresh_remain_value_all();
                continue;
            }
            if(R_Sudoku())
            {
                return true;
            }
            p[temp.x][temp.y] = 0;
            refresh_remain_value_all();
        }
        
    }
    p[temp.x][temp.y] = 0;
    list.push_back(temp);
    refresh_remain_value_all();
    return false;
}

void show_queue()
{
    int i;
    for(i=0;i<list.size();i++)
    {
        cout << "x position:" << list[i].x << "  y position:" << list[i].y << "  num:" << list[i].remain_value_num << endl;
    }
}

int main(int argc, char *argv[])
{
    string num;
    num = argv[1][0];
    clock_t clkStart, clkEnd;
    string filename = "..\\input\\sudoku0"+num;
    string out_filename = "..\\output\\sudoku0"+num;
    init_origin_sudoku(filename);
    show_sudoku_puzzle(p);
    build_queue();
    //cout << list.size() << endl;
    clkStart = clock();
    bool n = R_Sudoku();
    clkEnd = clock();
    if (!n) {
        printf("No possible solutions.");
    }
    cout << "Solution step is " << sum << endl;
    double endtime = (double)(clkEnd - clkStart) / CLOCKS_PER_SEC;
    cout << "Total time:" << endtime << endl;
    show_sudoku_puzzle(p);
    //show_queue();
    write_result(out_filename);
    cout << "save to file" << endl;
    return 0;
}
