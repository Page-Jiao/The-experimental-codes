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

void init_origin_sudoku(string name)
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

void show_sudoku_puzzle(Sudoku puzzle)
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
        if(j!=k && t==p[i][k])
            return false;
        if(i!=k && t==p[k][j])
            return false;
    }

    int iGrid=(i/3)*3;
    int jGrid=(j/3)*3;
    int k1,k2;
    for(k1=iGrid;k1<iGrid+3;k1++){
        for(k2=jGrid;k2<jGrid+3;k2++){
            if(k2==j && k1==i)
                continue;
            if(t==p[k1][k2])
                return false;
        }
    }
    if(i == j)
    {
        for(k=0;k<9;k++)
        {
            if(k == i)
                continue;
            else
            {
                if(t == p[k][k])
                    return false;
            }
            
        }
    }
    if(i + j == 8)
    {
        for(k=0;k<9;k++)
        {
            if(k == i)
                continue;
            else
            {
                if(t == p[k][8-k])
                    return false;
            }
            
        }
    }
    return true;
}

void compute_remain_value(position * m)
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
void build_queue()
{
    int i,j;
    position temp;
    for(i = 0; i < 9; i++)
    {
        for(j = 0; j < 9; j++)
        {
            if(p[i][j] != 0)
                continue;
            else
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

void refresh_remain_value_minus()
{
    position temp;
    for(int i=0;i<list.size();i++)
    {
        temp = list[i];
        for(int j=1;j<=9;j++)
        {
            if(!temp.remain_value[j])
            {
                continue;// 原来就是false，这次也是false
            }
            else
            {
                if(IsValid(temp.x,temp.y,j))
                    continue;
                else
                {
                    list[i].remain_value[j] = false;
                    list[i].remain_value_num -= 1;
                }
                
            }
            
        }
    }
}

void refresh_remain_value_all()
{
    position temp;
    int num = 0;
    for(int i=0;i<list.size();i++)
    {
        temp = list[i];
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

bool R_Sudoku()
{
    int i;
    sum +=1;
    position temp;
    if(list.size()==0)
        return true;
    temp = list.back();
    list.pop_back();
    for(i=1;i<=9;i++)
    {
        if(!temp.remain_value[i])
            continue;
        else
        {
            p[temp.x][temp.y] = i;
            refresh_remain_value_minus();
            sort(list.begin(),list.end(),cmp);//刷新剩余值表，再排序
            if(list[0].remain_value_num == 0)
            {
                p[temp.x][temp.y] = 0;
                list.push_back(temp);
                refresh_remain_value_all();
                sort(list.begin(),list.end(),cmp);
                return false;
            }
            if(R_Sudoku())
            {
                return true;
            }
            p[temp.x][temp.y] = 0;
            refresh_remain_value_all();
            sort(list.begin(),list.end(),cmp);
        }
        
    }
    p[temp.x][temp.y] = 0;
    list.push_back(temp);
    refresh_remain_value_all();
    sort(list.begin(),list.end(),cmp);
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
