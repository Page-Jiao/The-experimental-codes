/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/4/26 22:42:34                           */
/*==============================================================*/


alter table ���� 
   drop foreign key `FK_����_����-����_����`;

alter table �����˻� 
   drop foreign key `FK_�����˻�_�˻�-�����˻�_�˻�`;

alter table `Ա��-�ͻ�` 
   drop foreign key `FK_Ա��-�ͻ�_Ա��-�ͻ�_Ա��`;

alter table `Ա��-�ͻ�` 
   drop foreign key `FK_Ա��-�ͻ�_Ա��-�ͻ�2_�ͻ�`;

alter table `�ͻ�-�˻�` 
   drop foreign key `FK_�ͻ�-�˻�_�ͻ�-�˻�_�ͻ�`;

alter table `�ͻ�-�˻�` 
   drop foreign key `FK_�ͻ�-�˻�_�ͻ�-�˻�2_�˻�`;

alter table `�ͻ�-����` 
   drop foreign key `FK_�ͻ�-����_����_�ͻ�`;

alter table `�ͻ�-����` 
   drop foreign key `FK_�ͻ�-����_ӵ��_����`;

alter table ֧Ʊ�˻� 
   drop foreign key `FK_֧Ʊ�˻�_�˻�-֧Ʊ�˻�_�˻�`;

alter table ��ͨԱ�� 
   drop foreign key `FK_��ͨԱ��_Ա��-��ͨԱ��_Ա��`;

alter table �˻� 
   drop foreign key `FK_�˻�_֧��-�˻�_֧��`;

alter table ���� 
   drop foreign key `FK_����_֧��-����_֧��`;

alter table ���� 
   drop foreign key `FK_����_֧��-����_֧��`;

alter table `����-Ա��` 
   drop foreign key `FK_����-Ա��_����-Ա��_����`;

alter table `����-Ա��` 
   drop foreign key `FK_����-Ա��_����-Ա��2_Ա��`;

alter table ���ž��� 
   drop foreign key `FK_���ž���_Ա��-���ž���_Ա��`;


alter table ���� 
   drop foreign key `FK_����_����-����_����`;

drop table if exists ����;


alter table �����˻� 
   drop foreign key `FK_�����˻�_�˻�-�����˻�_�˻�`;

drop table if exists �����˻�;

drop table if exists Ա��;


alter table `Ա��-�ͻ�` 
   drop foreign key `FK_Ա��-�ͻ�_Ա��-�ͻ�_Ա��`;

alter table `Ա��-�ͻ�` 
   drop foreign key `FK_Ա��-�ͻ�_Ա��-�ͻ�2_�ͻ�`;

drop table if exists `Ա��-�ͻ�`;

drop table if exists �ͻ�;


alter table `�ͻ�-�˻�` 
   drop foreign key `FK_�ͻ�-�˻�_�ͻ�-�˻�_�ͻ�`;

alter table `�ͻ�-�˻�` 
   drop foreign key `FK_�ͻ�-�˻�_�ͻ�-�˻�2_�˻�`;

drop table if exists `�ͻ�-�˻�`;


alter table `�ͻ�-����` 
   drop foreign key `FK_�ͻ�-����_ӵ��_����`;

alter table `�ͻ�-����` 
   drop foreign key `FK_�ͻ�-����_����_�ͻ�`;

drop table if exists `�ͻ�-����`;


alter table ֧Ʊ�˻� 
   drop foreign key `FK_֧Ʊ�˻�_�˻�-֧Ʊ�˻�_�˻�`;

drop table if exists ֧Ʊ�˻�;

drop table if exists ֧��;


alter table ��ͨԱ�� 
   drop foreign key `FK_��ͨԱ��_Ա��-��ͨԱ��_Ա��`;

drop table if exists ��ͨԱ��;


alter table �˻� 
   drop foreign key `FK_�˻�_֧��-�˻�_֧��`;

drop table if exists �˻�;


alter table ���� 
   drop foreign key `FK_����_֧��-����_֧��`;

drop table if exists ����;


alter table ���� 
   drop foreign key `FK_����_֧��-����_֧��`;

drop table if exists ����;


alter table `����-Ա��` 
   drop foreign key `FK_����-Ա��_����-Ա��_����`;

alter table `����-Ա��` 
   drop foreign key `FK_����-Ա��_����-Ա��2_Ա��`;

drop table if exists `����-Ա��`;


alter table ���ž��� 
   drop foreign key `FK_���ž���_Ա��-���ž���_Ա��`;

drop table if exists ���ž���;

/*==============================================================*/
/* Table: ����                                                    */
/*==============================================================*/
create table ����
(
   �����                  numeric(20,0) not null  comment '',
   ����                   date  comment '',
   ���                   decimal  comment '',
   primary key (�����)
);

/*==============================================================*/
/* Table: �����˻�                                                  */
/*==============================================================*/
create table �����˻�
(
   �˻���                  numeric(20,0) not null  comment '',
   ����                   char(30)  comment '',
   �˻����                 decimal  comment '',
   ��������                 date  comment '',
   ����                   decimal  comment '',
   ��������                 char(10)  comment '',
   primary key (�˻���)
);

/*==============================================================*/
/* Table: Ա��                                                    */
/*==============================================================*/
create table Ա��
(
   ���֤��                 char(18) not null  comment '',
   ����                   char(10)  comment '',
   �绰����                 numeric(11,0)  comment '',
   ��ͥ��ַ                 char(30)  comment '',
   ��ʼ��������               date  comment '',
   ��Ӷ��                  int  comment '',
   primary key (���֤��)
);

/*==============================================================*/
/* Table: `Ա��-�ͻ�`                                               */
/*==============================================================*/
create table `Ա��-�ͻ�`
(
   ���֤��                 char(18) not null  comment '',
   �ͻ�_���֤��              char(18) not null  comment '',
   ��������                 char(10)  comment '',
   �������                 numeric(20,0)  comment '',
   primary key (���֤��, �ͻ�_���֤��)
);

/*==============================================================*/
/* Table: �ͻ�                                                    */
/*==============================================================*/
create table �ͻ�
(
   ���֤��                 char(18) not null  comment '',
   ����                   char(10)  comment '',
   �绰����                 numeric(11,0)  comment '',
   ��ͥסַ                 char(30)  comment '',
   ��ϵ������                char(10) not null  comment '',
   ��ϵ�˵绰����              numeric(11,0)  comment '',
   ��ϵ��Email             char(30)  comment '',
   ��ϵ�˹�ϵ                char(5)  comment '',
   primary key (���֤��)
);

/*==============================================================*/
/* Table: `�ͻ�-�˻�`                                               */
/*==============================================================*/
create table `�ͻ�-�˻�`
(
   ���֤��                 char(18) not null  comment '',
   �˻���                  numeric(20,0) not null  comment '',
   ��������                 date not null  comment '',
   primary key (���֤��, �˻���)
);

/*==============================================================*/
/* Table: `�ͻ�-����`                                               */
/*==============================================================*/
create table `�ͻ�-����`
(
   �����                  numeric(20,0) not null  comment '',
   ���֤��                 char(18) not null  comment '',
   primary key (�����, ���֤��)
);

/*==============================================================*/
/* Table: ֧Ʊ�˻�                                                  */
/*==============================================================*/
create table ֧Ʊ�˻�
(
   �˻���                  numeric(20,0) not null  comment '',
   ����                   char(30)  comment '',
   �˻����                 decimal  comment '',
   ��������                 date  comment '',
   ͸֧��                  decimal  comment '',
   primary key (�˻���)
);

/*==============================================================*/
/* Table: ֧��                                                    */
/*==============================================================*/
create table ֧��
(
   ����                   char(30) not null  comment '',
   ����                   char(10)  comment '',
   �ʲ�                   decimal  comment '',
   primary key (����)
);

/*==============================================================*/
/* Table: ��ͨԱ��                                                  */
/*==============================================================*/
create table ��ͨԱ��
(
   ���֤��                 char(18) not null  comment '',
   ����                   char(10)  comment '',
   �绰����                 numeric(11,0)  comment '',
   ��ͥ��ַ                 char(30)  comment '',
   ��ʼ��������               date  comment '',
   ��Ӷ��                  int  comment '',
   primary key (���֤��)
);

/*==============================================================*/
/* Table: �˻�                                                    */
/*==============================================================*/
create table �˻�
(
   �˻���                  numeric(20,0) not null  comment '',
   ����                   char(30) not null  comment '',
   �˻����                 decimal  comment '',
   ��������                 date  comment '',
   primary key (�˻���)
);

/*==============================================================*/
/* Table: ����                                                    */
/*==============================================================*/
create table ����
(
   �����                  numeric(20,0) not null  comment '',
   ����                   char(30) not null  comment '',
   ���                   decimal  comment '',
   primary key (�����)
);

/*==============================================================*/
/* Table: ����                                                    */
/*==============================================================*/
create table ����
(
   ���ź�                  numeric(10,0) not null  comment '',
   ����                   char(30) not null  comment '',
   ��������                 char(30)  comment '',
   ��������                 char(30)  comment '',
   primary key (���ź�)
);

/*==============================================================*/
/* Table: `����-Ա��`                                               */
/*==============================================================*/
create table `����-Ա��`
(
   ���ź�                  numeric(10,0) not null  comment '',
   ���֤��                 char(18) not null  comment '',
   ���ž������֤��             char(18)  comment '',
   primary key (���ź�, ���֤��)
);

/*==============================================================*/
/* Table: ���ž���                                                  */
/*==============================================================*/
create table ���ž���
(
   ���֤��                 char(18) not null  comment '',
   ����                   char(10)  comment '',
   �绰����                 numeric(11,0)  comment '',
   ��ͥ��ַ                 char(30)  comment '',
   ��ʼ��������               date  comment '',
   ��Ӷ��                  int  comment '',
   primary key (���֤��)
);

alter table ���� add constraint `FK_����_����-����_����` foreign key (�����)
      references ���� (�����) on delete restrict on update restrict;

alter table �����˻� add constraint `FK_�����˻�_�˻�-�����˻�_�˻�` foreign key (�˻���)
      references �˻� (�˻���) on delete restrict on update restrict;

alter table `Ա��-�ͻ�` add constraint `FK_Ա��-�ͻ�_Ա��-�ͻ�_Ա��` foreign key (���֤��)
      references Ա�� (���֤��) on delete restrict on update restrict;

alter table `Ա��-�ͻ�` add constraint `FK_Ա��-�ͻ�_Ա��-�ͻ�2_�ͻ�` foreign key (�ͻ�_���֤��)
      references �ͻ� (���֤��) on delete restrict on update restrict;

alter table `�ͻ�-�˻�` add constraint `FK_�ͻ�-�˻�_�ͻ�-�˻�_�ͻ�` foreign key (���֤��)
      references �ͻ� (���֤��) on delete restrict on update restrict;

alter table `�ͻ�-�˻�` add constraint `FK_�ͻ�-�˻�_�ͻ�-�˻�2_�˻�` foreign key (�˻���)
      references �˻� (�˻���) on delete restrict on update restrict;

alter table `�ͻ�-����` add constraint `FK_�ͻ�-����_����_�ͻ�` foreign key (���֤��)
      references �ͻ� (���֤��) on delete restrict on update restrict;

alter table `�ͻ�-����` add constraint `FK_�ͻ�-����_ӵ��_����` foreign key (�����)
      references ���� (�����) on delete restrict on update restrict;

alter table ֧Ʊ�˻� add constraint `FK_֧Ʊ�˻�_�˻�-֧Ʊ�˻�_�˻�` foreign key (�˻���)
      references �˻� (�˻���) on delete restrict on update restrict;

alter table ��ͨԱ�� add constraint `FK_��ͨԱ��_Ա��-��ͨԱ��_Ա��` foreign key (���֤��)
      references Ա�� (���֤��) on delete restrict on update restrict;

alter table �˻� add constraint `FK_�˻�_֧��-�˻�_֧��` foreign key (����)
      references ֧�� (����) on delete restrict on update restrict;

alter table ���� add constraint `FK_����_֧��-����_֧��` foreign key (����)
      references ֧�� (����) on delete restrict on update restrict;

alter table ���� add constraint `FK_����_֧��-����_֧��` foreign key (����)
      references ֧�� (����) on delete restrict on update restrict;

alter table `����-Ա��` add constraint `FK_����-Ա��_����-Ա��_����` foreign key (���ź�)
      references ���� (���ź�) on delete restrict on update restrict;

alter table `����-Ա��` add constraint `FK_����-Ա��_����-Ա��2_Ա��` foreign key (���֤��)
      references Ա�� (���֤��) on delete restrict on update restrict;

alter table ���ž��� add constraint `FK_���ž���_Ա��-���ž���_Ա��` foreign key (���֤��)
      references Ա�� (���֤��) on delete restrict on update restrict;

