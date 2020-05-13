/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/5/6 16:44:37                            */
/*==============================================================*/


alter table account 
   drop foreign key FK_ACCOUNT_CREATEACC_ACCOUNTB;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEBRA_BRANCHBA;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATER_CUSTOMER;

alter table checkAccount 
   drop foreign key FK_CHECKACC_CHECK_ACCOUNT;

alter table contacter 
   drop foreign key FK_CONTACTE_CLIENTCON_CUSTOMER;

alter table department 
   drop foreign key FK_DEPARTME_PARTMENTU_BRANCHBA;

alter table loan 
   drop foreign key FK_LOAN_LOANFROM_BRANCHBA;

alter table owner 
   drop foreign key FK_OWNER_OWNER_CUSTOMER;

alter table owner 
   drop foreign key FK_OWNER_OWNER2_ACCOUNT;

alter table payment 
   drop foreign key FK_PAYMENT_TOTALPAYM_LOAN;

alter table responsibler 
   drop foreign key FK_RESPONSI_RESPONSIB_STAFF;

alter table responsibler 
   drop foreign key FK_RESPONSI_RESPONSIB_CUSTOMER;

alter table saveAccount 
   drop foreign key FK_SAVEACCO_SAVE_ACCOUNT;

alter table staff 
   drop foreign key FK_STAFF_STAFFUNDE_DEPARTME;

alter table useLoan 
   drop foreign key FK_USELOAN_USELOAN_LOAN;

alter table useLoan 
   drop foreign key FK_USELOAN_USELOAN2_CUSTOMER;


alter table account 
   drop foreign key FK_ACCOUNT_CREATEACC_ACCOUNTB;

drop table if exists account;


alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATER_CUSTOMER;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEBRA_BRANCHBA;

drop table if exists accountBody;

drop table if exists branchBank;


alter table checkAccount 
   drop foreign key FK_CHECKACC_CHECK_ACCOUNT;

drop table if exists checkAccount;


alter table contacter 
   drop foreign key FK_CONTACTE_CLIENTCON_CUSTOMER;

drop table if exists contacter;

drop table if exists customer;


alter table department 
   drop foreign key FK_DEPARTME_PARTMENTU_BRANCHBA;

drop table if exists department;


alter table loan 
   drop foreign key FK_LOAN_LOANFROM_BRANCHBA;

drop table if exists loan;


alter table owner 
   drop foreign key FK_OWNER_OWNER_CUSTOMER;

alter table owner 
   drop foreign key FK_OWNER_OWNER2_ACCOUNT;

drop table if exists owner;


alter table payment 
   drop foreign key FK_PAYMENT_TOTALPAYM_LOAN;

drop table if exists payment;


alter table responsibler 
   drop foreign key FK_RESPONSI_RESPONSIB_STAFF;

alter table responsibler 
   drop foreign key FK_RESPONSI_RESPONSIB_CUSTOMER;

drop table if exists responsibler;


alter table saveAccount 
   drop foreign key FK_SAVEACCO_SAVE_ACCOUNT;

drop table if exists saveAccount;


alter table staff 
   drop foreign key FK_STAFF_STAFFUNDE_DEPARTME;

drop table if exists staff;


alter table useLoan 
   drop foreign key FK_USELOAN_USELOAN_LOAN;

alter table useLoan 
   drop foreign key FK_USELOAN_USELOAN2_CUSTOMER;

drop table if exists useLoan;

/*==============================================================*/
/* Table: account                                               */
/*==============================================================*/
create table account
(
   accountNum           varchar(20) not null  comment '',
   clientNum            varchar(20) not null  comment '',
   branchBankName       varchar(15) not null  comment '',
   accClass2            bool not null  comment '',
   accountMon           float(20,2)  comment '',
   accCreateTime        datetime not null  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: accountBody                                           */
/*==============================================================*/
create table accountBody
(
   clientNum            varchar(20) not null  comment '',
   branchBankName       varchar(15) not null  comment '',
   accClass2            bool not null  comment '',
   primary key (clientNum, branchBankName, accClass2)
);

/*==============================================================*/
/* Table: branchBank                                            */
/*==============================================================*/
create table branchBank
(
   branchBankName       varchar(15) not null  comment '',
   branBankMon          float(8,2)  comment '',
   branBankCity         varchar(20)  comment '',
   primary key (branchBankName)
);

/*==============================================================*/
/* Table: checkAccount                                          */
/*==============================================================*/
create table checkAccount
(
   accountNum           varchar(20) not null  comment '',
   overdraft            float(8,2) not null  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: contacter                                             */
/*==============================================================*/
create table contacter
(
   clientNum            varchar(20) not null  comment '',
   contactName          varchar(10) not null  comment '',
   contactPhone         numeric(11,0)  comment '',
   contactEmail         varchar(20)  comment '',
   relationship         varchar(20)  comment '',
   primary key (clientNum)
);

/*==============================================================*/
/* Table: customer                                              */
/*==============================================================*/
create table customer
(
   clientNum            varchar(20) not null  comment '',
   clientName           varchar(20)  comment '',
   clientPhone          varchar(20)  comment '',
   clientAddr           varchar(40)  comment '',
   primary key (clientNum)
);

/*==============================================================*/
/* Table: department                                            */
/*==============================================================*/
create table department
(
   departNum            numeric(10,0) not null  comment '',
   branchBankName       varchar(15) not null  comment '',
   departName           varchar(20)  comment '',
   managerNum           varchar(18)  comment '',
   primary key (departNum)
);

/*==============================================================*/
/* Table: loan                                                  */
/*==============================================================*/
create table loan
(
   loanNum              varchar(20) not null  comment '',
   branchBankName       varchar(15) not null  comment '',
   loanMoney            float(8,2)  comment '',
   payedMon             float(8,2)  comment '',
   primary key (loanNum)
);

/*==============================================================*/
/* Table: owner                                                 */
/*==============================================================*/
create table owner
(
   clientNum            varchar(20) not null  comment '',
   accountNum           varchar(20) not null  comment '',
   lastvisitedTime      datetime not null  comment '',
   primary key (clientNum, accountNum)
);

/*==============================================================*/
/* Table: payment                                               */
/*==============================================================*/
create table payment
(
   loanNum              varchar(20) not null  comment '',
   payDate              datetime not null  comment '',
   payMonOnece          float(8,2)  comment '',
   primary key (loanNum)
);

/*==============================================================*/
/* Table: responsibler                                          */
/*==============================================================*/
create table responsibler
(
   staffNum             varchar(18) not null  comment '',
   clientNum            varchar(20) not null  comment '',
   type                 varchar(10) not null  comment '',
   primary key (staffNum, clientNum)
);

/*==============================================================*/
/* Table: saveAccount                                           */
/*==============================================================*/
create table saveAccount
(
   accountNum           varchar(20) not null  comment '',
   rate                 decimal not null  comment '',
   moneyType            varchar(10) not null  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: staff                                                 */
/*==============================================================*/
create table staff
(
   staffNum             varchar(18) not null  comment '',
   departNum            numeric(10,0) not null  comment '',
   staffName            varchar(10)  comment '',
   staffPhone           numeric(11,0)  comment '',
   staffAddr            varchar(30)  comment '',
   staffReadyDay        date  comment '',
   primary key (staffNum)
);

/*==============================================================*/
/* Table: useLoan                                               */
/*==============================================================*/
create table useLoan
(
   loanNum              varchar(20) not null  comment '',
   clientNum            varchar(20) not null  comment '',
   primary key (loanNum, clientNum)
);

alter table account add constraint FK_ACCOUNT_CREATEACC_ACCOUNTB foreign key (clientNum, branchBankName, accClass2)
      references accountBody (clientNum, branchBankName, accClass2) on delete restrict on update restrict;

alter table accountBody add constraint FK_ACCOUNTB_CREATEBRA_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table accountBody add constraint FK_ACCOUNTB_CREATER_CUSTOMER foreign key (clientNum)
      references customer (clientNum) on delete restrict on update restrict;

alter table checkAccount add constraint FK_CHECKACC_CHECK_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table contacter add constraint FK_CONTACTE_CLIENTCON_CUSTOMER foreign key (clientNum)
      references customer (clientNum) on delete restrict on update restrict;

alter table department add constraint FK_DEPARTME_PARTMENTU_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table loan add constraint FK_LOAN_LOANFROM_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table owner add constraint FK_OWNER_OWNER_CUSTOMER foreign key (clientNum)
      references customer (clientNum) on delete restrict on update restrict;

alter table owner add constraint FK_OWNER_OWNER2_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table payment add constraint FK_PAYMENT_TOTALPAYM_LOAN foreign key (loanNum)
      references loan (loanNum) on delete restrict on update restrict;

alter table responsibler add constraint FK_RESPONSI_RESPONSIB_STAFF foreign key (staffNum)
      references staff (staffNum) on delete restrict on update restrict;

alter table responsibler add constraint FK_RESPONSI_RESPONSIB_CUSTOMER foreign key (clientNum)
      references customer (clientNum) on delete restrict on update restrict;

alter table saveAccount add constraint FK_SAVEACCO_SAVE_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table staff add constraint FK_STAFF_STAFFUNDE_DEPARTME foreign key (departNum)
      references department (departNum) on delete restrict on update restrict;

alter table useLoan add constraint FK_USELOAN_USELOAN_LOAN foreign key (loanNum)
      references loan (loanNum) on delete restrict on update restrict;

alter table useLoan add constraint FK_USELOAN_USELOAN2_CUSTOMER foreign key (clientNum)
      references customer (clientNum) on delete restrict on update restrict;

