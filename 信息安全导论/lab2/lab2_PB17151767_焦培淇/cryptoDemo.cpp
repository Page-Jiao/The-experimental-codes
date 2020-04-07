// cryptoDemo.cpp : Defines the entry point for the console application.
// Windows: cl cryptoDemo.cpp
// Linux: gcc -o cryptoDemo cryptoDemo.cpp -lcrypto

#include <memory.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "openssl\aes.h"

#pragma comment(lib,"libeay32.lib")

int main(int argc, char* argv[])
{
	//char inString[] = "This is a sample. I am a programer.\n";
	//char passwd[] = "0123456789ABCDEFGHIJK";
    if(argv[1][0]=='e')
	{
		printf("input file %s\n",argv[2]);
		FILE* f=fopen(argv[2],"rb");//open the file
		if(f==NULL)
		{
			printf("open file failed\n");
			return 0;
		}
		else
		{
			char* out_filename=(char*)malloc(sizeof(char)*(strlen(argv[2])+5));
			strcpy(out_filename,argv[2]);
			char suffix[]=".enc";
			strcat(out_filename,suffix);
			FILE* f2=fopen(out_filename,"wb");
			unsigned char buf[16];
			unsigned char buf2[16];
			unsigned char aes_keybuf[32];
			int read_size;
			int res_size=0;
			int i;
			memset(aes_keybuf,0x90,32);
			for(i=0;argv[3][i]!='\0';i++) aes_keybuf[i]=argv[3][i];
			AES_KEY aeskey;
			AES_set_encrypt_key(aes_keybuf,256,&aeskey);
			while(read_size=fread(buf,sizeof(unsigned char),16,f))
			{
				if(read_size==16)
				{
					AES_encrypt(buf,buf2,&aeskey);
					fwrite(buf2,sizeof(unsigned char),16,f2);
				}
				else
				{
					res_size=16-read_size;
					for(i=0;i<16-read_size;i++)
					{
						buf[read_size+i]=0;
					}
					AES_encrypt(buf,buf2,&aeskey);
					fwrite(buf2,sizeof(unsigned char),16,f2);
				}
			}
			buf2[0]=(unsigned char)res_size;
			fwrite(buf2,sizeof(unsigned char),16,f2);
			fclose(f);
			fclose(f2);
		}
	}
	else
	{
		FILE* f=fopen(argv[2],"rb");//open the file
		if(f==NULL)
		{
			printf("open file failed\n");
			return 0;
		}
		else
		{
			char* out_filename=(char*)malloc(sizeof(char)*(strlen(argv[2])));
			strcpy(out_filename,argv[2]);
			int i;
			char suffix[10];
			for(i=0;i<4;i++)
			{
				out_filename[strlen(argv[2])-i-1]='\0';
			}
			for(i=0;out_filename[i]!='.';i++);
			int point=i;
			strcpy(suffix,out_filename+i);
			for(;out_filename[i]!='\0';i++)out_filename[i]='\0';
			//printf("suffix  %s file %s",suffix,out_filename);
			out_filename[point]='1';
			strcat(out_filename,suffix);
			//printf("suffix  %s file %s",suffix,out_filename);
			
			//out_filename[strlen(argv[2])-3]='1';
			FILE* f2=fopen(out_filename,"wb");
			unsigned char buf[16];
			unsigned char buf2[16];
			unsigned char buf3[16];
			unsigned char aes_keybuf[32];
			int read_size;
			int res_size=0;
			memset(aes_keybuf,0x90,32);
			for(i=0;argv[3][i]!='\0';i++) aes_keybuf[i]=argv[3][i];
			AES_KEY aeskey;
			AES_set_decrypt_key(aes_keybuf,256,&aeskey);
			fseek(f, 0L, SEEK_END);
			int length=ftell(f);
			//printf("size of file %d\n",length);
			fseek(f, 0L, SEEK_SET);
			//printf("offset of fp %d and sizeof unsigned char %d\n",(int)ftell(f),sizeof(unsigned char));
			while(read_size=fread(buf,1,16,f))
			{
				//printf("offset of fp %d and %d\n",ftell(f),read_size);
				
				if(ftell(f)!=(length-16))
				{
					AES_decrypt(buf,buf2,&aeskey);
					fwrite(buf2,sizeof(unsigned char),16,f2);
				}
				else
				{
					fread(buf3,sizeof(unsigned char),16,f);
					res_size=buf3[0];
					AES_decrypt(buf,buf2,&aeskey);
					fwrite(buf2,sizeof(unsigned char),16-res_size,f2);
					break;
				}
				
			}
			fclose(f);
			fclose(f2);
			
			//fclose(f);
		}
	}
	//testAes(inString, strlen(inString), passwd, strlen(passwd));

	return 0;
}
