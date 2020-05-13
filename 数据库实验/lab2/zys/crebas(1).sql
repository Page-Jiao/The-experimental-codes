/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/4/26 22:42:34                           */
/*==============================================================*/


alter table 付款 
   drop foreign key `FK_付款_贷款-付款_贷款`;

alter table 储蓄账户 
   drop foreign key `FK_储蓄账户_账户-储蓄账户_账户`;

alter table `员工-客户` 
   drop foreign key `FK_员工-客户_员工-客户_员工`;

alter table `员工-客户` 
   drop foreign key `FK_员工-客户_员工-客户2_客户`;

alter table `客户-账户` 
   drop foreign key `FK_客户-账户_客户-账户_客户`;

alter table `客户-账户` 
   drop foreign key `FK_客户-账户_客户-账户2_账户`;

alter table `客户-贷款` 
   drop foreign key `FK_客户-贷款_属于_客户`;

alter table `客户-贷款` 
   drop foreign key `FK_客户-贷款_拥有_贷款`;

alter table 支票账户 
   drop foreign key `FK_支票账户_账户-支票账户_账户`;

alter table 普通员工 
   drop foreign key `FK_普通员工_员工-普通员工_员工`;

alter table 账户 
   drop foreign key `FK_账户_支行-账户_支行`;

alter table 贷款 
   drop foreign key `FK_贷款_支行-贷款_支行`;

alter table 部门 
   drop foreign key `FK_部门_支行-部门_支行`;

alter table `部门-员工` 
   drop foreign key `FK_部门-员工_部门-员工_部门`;

alter table `部门-员工` 
   drop foreign key `FK_部门-员工_部门-员工2_员工`;

alter table 部门经理 
   drop foreign key `FK_部门经理_员工-部门经理_员工`;


alter table 付款 
   drop foreign key `FK_付款_贷款-付款_贷款`;

drop table if exists 付款;


alter table 储蓄账户 
   drop foreign key `FK_储蓄账户_账户-储蓄账户_账户`;

drop table if exists 储蓄账户;

drop table if exists 员工;


alter table `员工-客户` 
   drop foreign key `FK_员工-客户_员工-客户_员工`;

alter table `员工-客户` 
   drop foreign key `FK_员工-客户_员工-客户2_客户`;

drop table if exists `员工-客户`;

drop table if exists 客户;


alter table `客户-账户` 
   drop foreign key `FK_客户-账户_客户-账户_客户`;

alter table `客户-账户` 
   drop foreign key `FK_客户-账户_客户-账户2_账户`;

drop table if exists `客户-账户`;


alter table `客户-贷款` 
   drop foreign key `FK_客户-贷款_拥有_贷款`;

alter table `客户-贷款` 
   drop foreign key `FK_客户-贷款_属于_客户`;

drop table if exists `客户-贷款`;


alter table 支票账户 
   drop foreign key `FK_支票账户_账户-支票账户_账户`;

drop table if exists 支票账户;

drop table if exists 支行;


alter table 普通员工 
   drop foreign key `FK_普通员工_员工-普通员工_员工`;

drop table if exists 普通员工;


alter table 账户 
   drop foreign key `FK_账户_支行-账户_支行`;

drop table if exists 账户;


alter table 贷款 
   drop foreign key `FK_贷款_支行-贷款_支行`;

drop table if exists 贷款;


alter table 部门 
   drop foreign key `FK_部门_支行-部门_支行`;

drop table if exists 部门;


alter table `部门-员工` 
   drop foreign key `FK_部门-员工_部门-员工_部门`;

alter table `部门-员工` 
   drop foreign key `FK_部门-员工_部门-员工2_员工`;

drop table if exists `部门-员工`;


alter table 部门经理 
   drop foreign key `FK_部门经理_员工-部门经理_员工`;

drop table if exists 部门经理;

/*==============================================================*/
/* Table: 付款                                                    */
/*==============================================================*/
create table 付款
(
   贷款号                  numeric(20,0) not null  comment '',
   日期                   date  comment '',
   金额                   decimal  comment '',
   primary key (贷款号)
);

/*==============================================================*/
/* Table: 储蓄账户                                                  */
/*==============================================================*/
create table 储蓄账户
(
   账户号                  numeric(20,0) not null  comment '',
   名字                   char(30)  comment '',
   账户余额                 decimal  comment '',
   开户日期                 date  comment '',
   利率                   decimal  comment '',
   货币类型                 char(10)  comment '',
   primary key (账户号)
);

/*==============================================================*/
/* Table: 员工                                                    */
/*==============================================================*/
create table 员工
(
   身份证号                 char(18) not null  comment '',
   姓名                   char(10)  comment '',
   电话号码                 numeric(11,0)  comment '',
   家庭地址                 char(30)  comment '',
   开始工作日期               date  comment '',
   雇佣期                  int  comment '',
   primary key (身份证号)
);

/*==============================================================*/
/* Table: `员工-客户`                                               */
/*==============================================================*/
create table `员工-客户`
(
   身份证号                 char(18) not null  comment '',
   客户_身份证号              char(18) not null  comment '',
   负责类型                 char(10)  comment '',
   负责号码                 numeric(20,0)  comment '',
   primary key (身份证号, 客户_身份证号)
);

/*==============================================================*/
/* Table: 客户                                                    */
/*==============================================================*/
create table 客户
(
   身份证号                 char(18) not null  comment '',
   姓名                   char(10)  comment '',
   电话号码                 numeric(11,0)  comment '',
   家庭住址                 char(30)  comment '',
   联系人姓名                char(10) not null  comment '',
   联系人电话号码              numeric(11,0)  comment '',
   联系人Email             char(30)  comment '',
   联系人关系                char(5)  comment '',
   primary key (身份证号)
);

/*==============================================================*/
/* Table: `客户-账户`                                               */
/*==============================================================*/
create table `客户-账户`
(
   身份证号                 char(18) not null  comment '',
   账户号                  numeric(20,0) not null  comment '',
   访问日期                 date not null  comment '',
   primary key (身份证号, 账户号)
);

/*==============================================================*/
/* Table: `客户-贷款`                                               */
/*==============================================================*/
create table `客户-贷款`
(
   贷款号                  numeric(20,0) not null  comment '',
   身份证号                 char(18) not null  comment '',
   primary key (贷款号, 身份证号)
);

/*==============================================================*/
/* Table: 支票账户                                                  */
/*==============================================================*/
create table 支票账户
(
   账户号                  numeric(20,0) not null  comment '',
   名字                   char(30)  comment '',
   账户余额                 decimal  comment '',
   开户日期                 date  comment '',
   透支额                  decimal  comment '',
   primary key (账户号)
);

/*==============================================================*/
/* Table: 支行                                                    */
/*==============================================================*/
create table 支行
(
   名字                   char(30) not null  comment '',
   城市                   char(10)  comment '',
   资产                   decimal  comment '',
   primary key (名字)
);

/*==============================================================*/
/* Table: 普通员工                                                  */
/*==============================================================*/
create table 普通员工
(
   身份证号                 char(18) not null  comment '',
   姓名                   char(10)  comment '',
   电话号码                 numeric(11,0)  comment '',
   家庭地址                 char(30)  comment '',
   开始工作日期               date  comment '',
   雇佣期                  int  comment '',
   primary key (身份证号)
);

/*==============================================================*/
/* Table: 账户                                                    */
/*==============================================================*/
create table 账户
(
   账户号                  numeric(20,0) not null  comment '',
   名字                   char(30) not null  comment '',
   账户余额                 decimal  comment '',
   开户日期                 date  comment '',
   primary key (账户号)
);

/*==============================================================*/
/* Table: 贷款                                                    */
/*==============================================================*/
create table 贷款
(
   贷款号                  numeric(20,0) not null  comment '',
   名字                   char(30) not null  comment '',
   金额                   decimal  comment '',
   primary key (贷款号)
);

/*==============================================================*/
/* Table: 部门                                                    */
/*==============================================================*/
create table 部门
(
   部门号                  numeric(10,0) not null  comment '',
   名字                   char(30) not null  comment '',
   部门名称                 char(30)  comment '',
   部门类型                 char(30)  comment '',
   primary key (部门号)
);

/*==============================================================*/
/* Table: `部门-员工`                                               */
/*==============================================================*/
create table `部门-员工`
(
   部门号                  numeric(10,0) not null  comment '',
   身份证号                 char(18) not null  comment '',
   部门经理身份证号             char(18)  comment '',
   primary key (部门号, 身份证号)
);

/*==============================================================*/
/* Table: 部门经理                                                  */
/*==============================================================*/
create table 部门经理
(
   身份证号                 char(18) not null  comment '',
   姓名                   char(10)  comment '',
   电话号码                 numeric(11,0)  comment '',
   家庭地址                 char(30)  comment '',
   开始工作日期               date  comment '',
   雇佣期                  int  comment '',
   primary key (身份证号)
);

alter table 付款 add constraint `FK_付款_贷款-付款_贷款` foreign key (贷款号)
      references 贷款 (贷款号) on delete restrict on update restrict;

alter table 储蓄账户 add constraint `FK_储蓄账户_账户-储蓄账户_账户` foreign key (账户号)
      references 账户 (账户号) on delete restrict on update restrict;

alter table `员工-客户` add constraint `FK_员工-客户_员工-客户_员工` foreign key (身份证号)
      references 员工 (身份证号) on delete restrict on update restrict;

alter table `员工-客户` add constraint `FK_员工-客户_员工-客户2_客户` foreign key (客户_身份证号)
      references 客户 (身份证号) on delete restrict on update restrict;

alter table `客户-账户` add constraint `FK_客户-账户_客户-账户_客户` foreign key (身份证号)
      references 客户 (身份证号) on delete restrict on update restrict;

alter table `客户-账户` add constraint `FK_客户-账户_客户-账户2_账户` foreign key (账户号)
      references 账户 (账户号) on delete restrict on update restrict;

alter table `客户-贷款` add constraint `FK_客户-贷款_属于_客户` foreign key (身份证号)
      references 客户 (身份证号) on delete restrict on update restrict;

alter table `客户-贷款` add constraint `FK_客户-贷款_拥有_贷款` foreign key (贷款号)
      references 贷款 (贷款号) on delete restrict on update restrict;

alter table 支票账户 add constraint `FK_支票账户_账户-支票账户_账户` foreign key (账户号)
      references 账户 (账户号) on delete restrict on update restrict;

alter table 普通员工 add constraint `FK_普通员工_员工-普通员工_员工` foreign key (身份证号)
      references 员工 (身份证号) on delete restrict on update restrict;

alter table 账户 add constraint `FK_账户_支行-账户_支行` foreign key (名字)
      references 支行 (名字) on delete restrict on update restrict;

alter table 贷款 add constraint `FK_贷款_支行-贷款_支行` foreign key (名字)
      references 支行 (名字) on delete restrict on update restrict;

alter table 部门 add constraint `FK_部门_支行-部门_支行` foreign key (名字)
      references 支行 (名字) on delete restrict on update restrict;

alter table `部门-员工` add constraint `FK_部门-员工_部门-员工_部门` foreign key (部门号)
      references 部门 (部门号) on delete restrict on update restrict;

alter table `部门-员工` add constraint `FK_部门-员工_部门-员工2_员工` foreign key (身份证号)
      references 员工 (身份证号) on delete restrict on update restrict;

alter table 部门经理 add constraint `FK_部门经理_员工-部门经理_员工` foreign key (身份证号)
      references 员工 (身份证号) on delete restrict on update restrict;

