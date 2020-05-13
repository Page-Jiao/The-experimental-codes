/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2020/5/5 16:49:15                            */
/*==============================================================*/

alter table account 
   drop foreign key FK_ACCOUNT_CREATEACC_ACCOUNTB;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEACC_ACCOUNT;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEBRA_BRANCHBA;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATER_CLIENT;

alter table checkAccount 
   drop foreign key FK_CHECKACC_CHECK_ACCOUNT;

alter table client 
   drop foreign key FK_CLIENT_BANKACCCH_STAFF;

alter table client 
   drop foreign key FK_CLIENT_CLIENTCON_CONTACT;

alter table client 
   drop foreign key FK_CLIENT_LOANCHARG_STAFF;

alter table department 
   drop foreign key FK_DEPARTME_PARTMENTU_BRANCHBA;

alter table loan 
   drop foreign key FK_LOAN_LOANSOURC_BRANCHBA;

alter table loanUsage 
   drop foreign key FK_LOANUSAG_LOANUSAGE_LOAN;

alter table loanUsage 
   drop foreign key FK_LOANUSAG_LOANUSAGE_CLIENT;

alter table owner 
   drop foreign key FK_OWNER_OWNER_CLIENT;

alter table owner 
   drop foreign key FK_OWNER_OWNER2_ACCOUNT;

alter table payment 
   drop foreign key FK_PAYMENT_TOTALPAYM_LOAN;

alter table saveAccount 
   drop foreign key FK_SAVEACCO_SAVE_ACCOUNT;

alter table staff 
   drop foreign key FK_STAFF_STAFFUNDE_DEPARTME;


alter table account 
   drop foreign key FK_ACCOUNT_CREATEACC_ACCOUNTB;

drop table if exists account;


alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEACC_ACCOUNT;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATER_CLIENT;

alter table accountBody 
   drop foreign key FK_ACCOUNTB_CREATEBRA_BRANCHBA;

drop table if exists accountBody;

drop table if exists branchBank;


alter table checkAccount 
   drop foreign key FK_CHECKACC_CHECK_ACCOUNT;

drop table if exists checkAccount;


alter table client 
   drop foreign key FK_CLIENT_CLIENTCON_CONTACT;

alter table client 
   drop foreign key FK_CLIENT_BANKACCCH_STAFF;

alter table client 
   drop foreign key FK_CLIENT_LOANCHARG_STAFF;

drop table if exists client;

drop table if exists contact;


alter table department 
   drop foreign key FK_DEPARTME_PARTMENTU_BRANCHBA;

drop table if exists department;


alter table loan 
   drop foreign key FK_LOAN_LOANSOURC_BRANCHBA;

drop table if exists loan;


alter table loanUsage 
   drop foreign key FK_LOANUSAG_LOANUSAGE_LOAN;

alter table loanUsage 
   drop foreign key FK_LOANUSAG_LOANUSAGE_CLIENT;

drop table if exists loanUsage;


alter table owner 
   drop foreign key FK_OWNER_OWNER_CLIENT;

alter table owner 
   drop foreign key FK_OWNER_OWNER2_ACCOUNT;

drop table if exists owner;


alter table payment 
   drop foreign key FK_PAYMENT_TOTALPAYM_LOAN;

drop table if exists payment;


alter table saveAccount 
   drop foreign key FK_SAVEACCO_SAVE_ACCOUNT;

drop table if exists saveAccount;


alter table staff 
   drop foreign key FK_STAFF_STAFFUNDE_DEPARTME;

drop table if exists staff;

/*==============================================================*/
/* Table: account                                               */
/*==============================================================*/
create table account
(
   accountNum           varchar(20) not null  comment '',
   clientNum            varchar(20)  comment '',
   branchBankName       varchar(20)  comment '',
   accClass2            bool  comment '',
   accountMon           float(20,2)  comment '',
   accCreateTime        datetime  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: accountBody                                           */
/*==============================================================*/
create table accountBody
(
   clientNum            varchar(20) not null  comment '',
   branchBankName       varchar(20) not null  comment '',
   accClass2            bool not null  comment '',
   accountNum           varchar(20)  comment '',
   primary key (clientNum, branchBankName, accClass2)
);

/*==============================================================*/
/* Table: branchBank                                            */
/*==============================================================*/
create table branchBank
(
   branchBankName       varchar(20) not null  comment '',
   branBankMon          float(16,2)  comment '',
   branBankCity         varchar(20)  comment '',
   primary key (branchBankName)
);

/*==============================================================*/
/* Table: checkAccount                                          */
/*==============================================================*/
create table checkAccount
(
   accountNum           varchar(20) not null  comment '',
   overdraft            float(20,2) not null  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: client                                                */
/*==============================================================*/
create table client
(
   clientNum            varchar(20) not null  comment '',
   staffNum             varchar(20)  comment '',
   contactName          varchar(20) not null  comment '',
   sta_staffNum         varchar(20)  comment '',
   clientName           varchar(20)  comment '',
   clientPhone          varchar(20)  comment '',
   clientAddr           varchar(40)  comment '',
   relationship         varchar(20) not null  comment '',
   primary key (clientNum)
);

/*==============================================================*/
/* Table: contact                                               */
/*==============================================================*/
create table contact
(
   contactName          varchar(20) not null  comment '',
   contactPhone         varchar(20)  comment '',
   contactEmail         varchar(20)  comment '',
   primary key (contactName)
);

/*==============================================================*/
/* Table: department                                            */
/*==============================================================*/
create table department
(
   departNum            varchar(20) not null  comment '',
   branchBankName       varchar(20)  comment '',
   departName           varchar(20)  comment '',
   managerNum           varchar(20)  comment '',
   primary key (departNum)
);

/*==============================================================*/
/* Table: loan                                                  */
/*==============================================================*/
create table loan
(
   loanNum              varchar(20) not null  comment '',
   branchBankName       varchar(20)  comment '',
   loanMoney            float(20,2)  comment '',
   loanOrder            int  comment '',
   loanTotalOrder       int  comment '',
   payedMon             float(20,2)  comment '',
   primary key (loanNum)
);

/*==============================================================*/
/* Table: loanUsage                                             */
/*==============================================================*/
create table loanUsage
(
   loanNum              varchar(20) not null  comment '',
   clientNum            varchar(20) not null  comment '',
   primary key (loanNum, clientNum)
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
   payMonOnece          float(20,2)  comment '',
   primary key (loanNum, payDate)
);

/*==============================================================*/
/* Table: saveAccount                                           */
/*==============================================================*/
create table saveAccount
(
   accountNum           varchar(20) not null  comment '',
   rate                 decimal(10,2) not null  comment '',
   moneyType            varchar(20) not null  comment '',
   primary key (accountNum)
);

/*==============================================================*/
/* Table: staff                                                 */
/*==============================================================*/
create table staff
(
   staffNum             varchar(20) not null  comment '',
   departNum            varchar(20)  comment '',
   staffName            varchar(20)  comment '',
   staffPhone           varchar(20)  comment '',
   staffAddr            varchar(20)  comment '',
   staffReadyDay        date  comment '',
   primary key (staffNum)
);

alter table account add constraint FK_ACCOUNT_CREATEACC_ACCOUNTB foreign key (clientNum, branchBankName, accClass2)
      references accountBody (clientNum, branchBankName, accClass2) on delete restrict on update restrict;

alter table accountBody add constraint FK_ACCOUNTB_CREATEACC_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table accountBody add constraint FK_ACCOUNTB_CREATEBRA_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table accountBody add constraint FK_ACCOUNTB_CREATER_CLIENT foreign key (clientNum)
      references client (clientNum) on delete restrict on update restrict;

alter table checkAccount add constraint FK_CHECKACC_CHECK_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table client add constraint FK_CLIENT_BANKACCCH_STAFF foreign key (staffNum)
      references staff (staffNum) on delete restrict on update restrict;

alter table client add constraint FK_CLIENT_CLIENTCON_CONTACT foreign key (contactName)
      references contact (contactName) on delete restrict on update restrict;

alter table client add constraint FK_CLIENT_LOANCHARG_STAFF foreign key (sta_staffNum)
      references staff (staffNum) on delete restrict on update restrict;

alter table department add constraint FK_DEPARTME_PARTMENTU_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table loan add constraint FK_LOAN_LOANSOURC_BRANCHBA foreign key (branchBankName)
      references branchBank (branchBankName) on delete restrict on update restrict;

alter table loanUsage add constraint FK_LOANUSAG_LOANUSAGE_LOAN foreign key (loanNum)
      references loan (loanNum) on delete restrict on update restrict;

alter table loanUsage add constraint FK_LOANUSAG_LOANUSAGE_CLIENT foreign key (clientNum)
      references client (clientNum) on delete restrict on update restrict;

alter table owner add constraint FK_OWNER_OWNER_CLIENT foreign key (clientNum)
      references client (clientNum) on delete restrict on update restrict;

alter table owner add constraint FK_OWNER_OWNER2_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table payment add constraint FK_PAYMENT_TOTALPAYM_LOAN foreign key (loanNum)
      references loan (loanNum) on delete restrict on update restrict;

alter table saveAccount add constraint FK_SAVEACCO_SAVE_ACCOUNT foreign key (accountNum)
      references account (accountNum) on delete restrict on update restrict;

alter table staff add constraint FK_STAFF_STAFFUNDE_DEPARTME foreign key (departNum)
      references department (departNum) on delete restrict on update restrict;

