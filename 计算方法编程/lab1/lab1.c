#include<stdio.h>
#include<math.h>
float f_x(float x)
{
    return sqrt(x*x+9)-3;
}
float g_x(float x)
{
    return x*x/(sqrt(x*x+9)+3);
}
int main()
{
    float x=8;
    int i;
    for(i=1;i<=10;i++)
    {
        printf("%d %f %f\n",i,f_x(pow(x,-i)),g_x(pow(x,-i)));
    }
}