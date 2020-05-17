#include <iostream>
#include <fstream>
#include <sstream>
#include <assert.h>
#include <string>
#include <cmath>
#include <vector>
#include <time.h>

using namespace std;
typedef int Sudoku[9][9];
Sudoku p;
int sum = 0;

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

bool IsValid(int i,int j)//判断当前位置是否合法
{
    int  t=p[i][j];
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

bool R_Sudoku()// 循环回溯求解问题
{
    sum +=1;
    int i,j,k;
    for(i=0;i<9;i++){
        for(j=0;j<9;j++){
            if(p[i][j]==0){
                for(k=1;k<10;k++){
                    p[i][j]=k;
                    if(IsValid(i,j) && R_Sudoku()){
                        return true;
                    }
                    p[i][j]=0;
                }
                return false;
            }
        }
    }
    return true;
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

int main(int argc, char *argv[])
{
    string num;
    num = argv[1][0];
    clock_t clkStart, clkEnd;
    string filename = "..\\input\\sudoku0"+num;
    string out_filename = "..\\output\\sudoku0"+num;
    init_origin_sudoku(filename);
    show_sudoku_puzzle(p);
    clkStart = clock();
    bool n = R_Sudoku();
    clkEnd = clock();
    if (!n) {
        printf("No possible solutions.");
    }
    cout << "Solution step is  " << sum << endl;
    double endtime = (double)(clkEnd - clkStart) / CLOCKS_PER_SEC;
    cout << "Total time:" << endtime << endl;
    show_sudoku_puzzle(p);
    write_result(out_filename);
    cout << "save to file" << endl;
    return 0;
}
