create table ast_tara
(
    id_tara number(9, 0) not null,
    denumire varchar2(20),
    constraint tara_pk primary key (id_tara)
);

create table ast_oras
(
    id_oras number(9, 0) not null,
    denumire varchar2(20),
    id_tara number(9,0),
    constraint oras_pk primary key (id_oras),
    constraint oras_tara_fk1 foreign key (id_tara) references ast_tara(id_tara)
);

create table ast_fashionweek
(
    id_evenimet number(9,0) not null,
    data_inceput date,
    data_sfarsit date,
    id_oras number(9,0),
    constraint fashionweek_pk primary key (id_evenimet),
    constraint fashionweek_oras_fk1 foreign key (id_oras) references ast_oras(id_oras)
);

create table ast_post_tv
(
    id_post number(9,0) not null,
    denumire varchar2(20),
    emisiune varchar2(20),
    constraint post_tv_pk primary key (id_post)
);

create table ast_presa
(
    id_jurnalist number(9,0) not null,
    nume varchar2(25),
    prenume varchar2(25),
    angajator varchar2(25),
    constraint presa_pk primary key (id_jurnalist)
);

create table ast_promoveaza
(
    id_eveniment number(9,0) not null,
    id_post number(9,0) not null,
    id_jurnalist number(9,0) not null,
    durata number(3),
    vizualizari number(9),
    constraint promoveaza_pk primary key (id_eveniment, id_post, id_jurnalist)
);

alter table ast_promoveaza
add constraint promoveaza_fashionweek_fk1 foreign key (id_eveniment) references ast_fashionweek(id_evenimet);

alter table ast_promoveaza
add constraint promoveaza_post_tv_fk1 foreign key (id_post) references ast_post_tv(id_post);

alter table ast_promoveaza
add constraint promoveaza_presa_fk1 foreign key (id_jurnalist) references ast_presa(id_jurnalist);

create table ast_participanti
(
    id_participant number(9,0) not null,
    prenume varchar2(25),
    nume varchar2(25),
    constraint participanti_pk primary key (id_participant)
);

create table ast_participa
(
    id_eveniment number(9,0) not null,
    id_participant number(9,0) not null,
    discount number(9,2),
    constraint participa_pk primary key (id_participant, id_eveniment)
);

alter table ast_participa
add constraint participa_fashionweek_fk1 foreign key (id_eveniment) references ast_fashionweek(id_evenimet);

alter table ast_participa
add constraint participa_participant_fk1 foreign key (id_participant) references ast_participanti(id_participant);

create table ast_locuri
(
    id_loc number(9,0) not null,
    id_participant number(9,0),
    pret number(9) not null,
    disponibilitate number(1),
    constraint disponibilitate_ck check ( disponibilitate in (1,0) ),
    constraint locuri_pk primary key (id_loc),
    constraint locuri_participanti_fk1 foreign key (id_participant) references ast_participanti(id_participant)
);

create table ast_loc_vip
(
    id_loc number(9,0) not null,
    id_participant number(9,0),
    pret number(9) not null,
    disponibilitate number(1),
    pozitie varchar2(10),
    constraint disponibilitate_vip_ck check ( disponibilitate in (1,0) ),
    constraint loc_vip_pk primary key (id_loc),
    constraint loc_vip_participanti_fk1 foreign key (id_participant) references ast_participanti(id_participant)
);

create table ast_defilare
(
    id_defilare number(9,0) not null,
    id_eveniment number(9,0) not null,
    ora_inceput varchar2(10),
    ora_final varchar2(10),
    constraint defilare_pk primary key (id_defilare),
    constraint defilare_fashionweek_fk1 foreign key (id_eveniment) references ast_fashionweek(id_evenimet)
);

create table ast_nationalitate
(
    id_nationalitate number(9,0) not null,
    denumire varchar2(20),
    constraint nationalitate_pk primary key (id_nationalitate)
);

create table ast_fotomodel
(
    id_fotomodel number(9,0) not null,
    id_nationalitate number(9,0),
    nume varchar2(25),
    prenume varchar2(25),
    data_nasterii date,
    constraint fotomodel_pk primary key (id_fotomodel),
    constraint fotomodel_nationalitate_fk1 foreign key (id_nationalitate) references ast_nationalitate(id_nationalitate)
);

alter table ast_fotomodel
add salariu number(9);

create table ast_brand
(
    id_brand number(9,0) not null,
    denumire varchar2(20),
    sediu varchar2(20),
    constraint brand_pk primary key (id_brand)
);

create table ast_ia_parte
(
    id_eveniment number(9,0) not null,
    id_brand number(9,0) not null,
    taxa_participare number(4),
    constraint ia_parte_pk primary key (id_brand, id_eveniment),
    constraint ia_parte_fashionweek_fk1 foreign key (id_eveniment) references ast_fashionweek(id_evenimet),
    constraint ia_part_brand_fk1 foreign key (id_brand) references ast_brand(id_brand)
);

alter table ast_ia_parte
drop constraint ia_parte_pk;

alter table ast_ia_parte
add constraint ia_parte_pk primary key (id_brand, id_eveniment, taxa_participare);

create table ast_colectii
(
    id_colectie number(9,0) not null,
    id_brand number(9,0) not null,
    sezon varchar2(20),
    tematica varchar2(25),
    constraint colectii_pk primary key (id_colectie),
    constraint colectii_brand_fk1 foreign key (id_brand) references ast_brand(id_brand)
);

create table ast_tinute
(
    id_tinuta number(9,0) not null,
    id_colectie number(9,0),
    pret number(5,2),
    material varchar2(15),
    constraint tinute_pk primary key (id_tinuta),
    constraint tinute_colectie_fk1 foreign key (id_colectie) references ast_colectii(id_colectie)
);

alter table ast_tinute
modify pret number(9,2);

create table ast_cumpara
(
    id_participant number(9,0) not null,
    id_tinuta number(9,0) not null,
    marime varchar2(1),
    discount number(9,2),
    constraint marime_ck check ( marime in ('XS','S','M','L','XL') ),
    constraint cumpara_pk primary key (id_tinuta, id_participant),
    constraint cumpara_participant_fk1 foreign key (id_participant) references ast_participanti(id_participant),
    constraint cumpara_tinuta_fk1 foreign key (id_tinuta) references ast_tinute(id_tinuta)
);

alter table ast_cumpara
modify marime varchar2(2);

create table ast_prezinta
(
    id_fotomodel number(9,0) not null,
    id_defilare number(9,0) not null,
    id_tinuta number(9,0) not null,
    data_prezentare date,
    constraint prezinta_pk primary key (id_fotomodel, id_defilare, id_tinuta),
    constraint prezinta_fotomodel_fk1 foreign key (id_fotomodel) references ast_fotomodel(id_fotomodel),
    constraint prezinta_defilare_fk1 foreign key (id_defilare) references ast_defilare(id_defilare),
    constraint prezinta_tinuta_fk1 foreign key (id_tinuta) references ast_tinute(id_tinuta)
);

insert into ast_tara (id_tara, denumire) values(10, 'Italia');
insert into ast_tara (id_tara, denumire) values(11, 'SUA');
insert into ast_tara (id_tara, denumire) values(12, 'Romania');
insert into ast_tara (id_tara, denumire) values(13, 'Singapore');
insert into ast_tara (id_tara, denumire) values(14, 'Franta');

insert into ast_oras (id_oras, denumire, id_tara) values(101, 'Milano', 10);
insert into ast_oras (id_oras, denumire, id_tara) values(102, 'Singapore', 13);
insert into ast_oras (id_oras, denumire, id_tara) values(103, 'New York', 11);
insert into ast_oras (id_oras, denumire, id_tara) values(104, 'Paris', 14);
insert into ast_oras (id_oras, denumire, id_tara) values(105, 'Bucuresti', 12);

insert into ast_fashionweek (id_evenimet, data_inceput, data_sfarsit, id_oras) values (101, to_timestamp('01-aug-2017','dd-mon-rr hh.mi.ssxff am'), to_timestamp('06-aug-2017','dd-mon-rr hh.mi.ssxff am'), 102);
insert into ast_fashionweek (id_evenimet, data_inceput, data_sfarsit, id_oras) values (105, to_timestamp('02-jul-2014','dd-mon-rr hh.mi.ssxff am'), to_timestamp('09-jul-2014','dd-mon-rr hh.mi.ssxff am'), 101);
insert into ast_fashionweek (id_evenimet, data_inceput, data_sfarsit, id_oras) values (203, to_timestamp('7-oct-2013','dd-mon-rr hh.mi.ssxff am'), to_timestamp('15-oct-2013','dd-mon-rr hh.mi.ssxff am'), 104);
insert into ast_fashionweek (id_evenimet, data_inceput, data_sfarsit, id_oras) values (304, to_timestamp('03-nov-2015','dd-mon-rr hh.mi.ssxff am'), to_timestamp('08-nov-2015','dd-mon-rr hh.mi.ssxff am'), 103);
insert into ast_fashionweek (id_evenimet, data_inceput, data_sfarsit, id_oras) values (406, to_timestamp('17-jun-2016','dd-mon-rr hh.mi.ssxff am'), to_timestamp('25-jun-2016','dd-mon-rr hh.mi.ssxff am'), 103);

insert into ast_post_tv (id_post, denumire, emisiune) values (1,'CNN', 'Fashion time');
insert into ast_post_tv (id_post, denumire) values (2,'TV');
insert into ast_post_tv (id_post, denumire, emisiune) values (3,'Fashion tv', 'Fashion time show');
insert into ast_post_tv (id_post, denumire) values (4,'Antena3');
insert into ast_post_tv (id_post, denumire, emisiune) values (5,'Antena Star', 'Star matinal');

insert into ast_presa (id_jurnalist, nume, prenume) values (20, 'Chris','Stuard');
insert into ast_presa (id_jurnalist, nume, prenume, angajator) values (21, 'Anna','Collins', 'Vogue');
insert into ast_presa (id_jurnalist, nume, prenume, angajator) values (22, 'Ellen','Hopkins', 'CNN');
insert into ast_presa (id_jurnalist, nume, prenume, angajator) values (23, 'Alexandra','Morar', 'Antena');
insert into ast_presa (id_jurnalist, nume, prenume) values (24, 'Emily','Jones');

insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (101,1,22,15,150000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (101,2,24,30,1000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (105,3,20,10,12000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (105,6,23,3,8000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (203,4,21,2,1000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (203,2,21,5,9000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (304,1,22,10,130000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (304,5,23,3,3000);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (406,2,24,5,1200);
insert into ast_promoveaza (id_eveniment, id_post, id_jurnalist, durata, vizualizari) values (406,4,20,3,8800);

insert into ast_participanti (id_participant, prenume, nume) values (151,'Sandu','Aurel');
insert into ast_participanti (id_participant, prenume, nume) values (161,'Carmen','Diaconescu');
insert into ast_participanti (id_participant, prenume, nume) values (207,'Jane','Stuard');
insert into ast_participanti (id_participant, prenume, nume) values (306,'Michele','Marsh');
insert into ast_participanti (id_participant, prenume, nume) values (450,'Robin','Smith');
insert into ast_participanti (id_participant, prenume, nume) values (351,'Sandy','Butler');

insert into ast_participa (id_eveniment, id_participant, discount) values (101,151,0.3);
insert into ast_participa (id_eveniment, id_participant) values (101,306);
insert into ast_participa (id_eveniment, id_participant, discount) values (203,161,0.1);
insert into ast_participa (id_eveniment, id_participant) values (203,450);
insert into ast_participa (id_eveniment, id_participant) values (105,161);
insert into ast_participa (id_eveniment, id_participant) values (105,450);
insert into ast_participa (id_eveniment, id_participant, discount) values (105,207,0.2);
insert into ast_participa (id_eveniment, id_participant, discount) values (406,306,0.2);
insert into ast_participa (id_eveniment, id_participant) values (406,151);
insert into ast_participa (id_eveniment, id_participant) values (304,306);

insert into ast_locuri (id_loc, id_participant, pret, disponibilitate) values (35,151, 150,1);
insert into ast_locuri (id_loc, pret, disponibilitate) values (36, 150,0);
insert into ast_locuri (id_loc, id_participant, pret, disponibilitate) values (37,207, 150,1);
insert into ast_locuri (id_loc, id_participant, pret, disponibilitate) values (38,207, 150,1);
insert into ast_locuri (id_loc, pret, disponibilitate) values (39, 150,0);
insert into ast_locuri (id_loc, id_participant, pret, disponibilitate) values (40,161, 150,1);
insert into ast_locuri (id_loc, id_participant, pret, disponibilitate) values (41,161, 150,1);

insert into ast_loc_vip (id_loc, id_participant, pret, disponibilitate, pozitie) values (1,450,350,1,'zona 0');
insert into ast_loc_vip (id_loc, id_participant, pret, disponibilitate, pozitie) values (2,450,350,1,'zona 0');
insert into ast_loc_vip (id_loc, pret, disponibilitate, pozitie) values (3,350,0,'zona 0');
insert into ast_loc_vip (id_loc, id_participant, pret, disponibilitate, pozitie) values (4,351,350,1,'zona 0');
insert into ast_loc_vip (id_loc, id_participant, pret, disponibilitate, pozitie) values (8,306,350,1,'zona 0');
insert into ast_loc_vip (id_loc, id_participant, pret, disponibilitate, pozitie) values (9,306,350,1,'zona 0');

insert into ast_nationalitate (id_nationalitate, denumire) values (1, 'americana');
insert into ast_nationalitate (id_nationalitate, denumire) values (2, 'engleza');
insert into ast_nationalitate (id_nationalitate, denumire) values (3, 'spaniola');
insert into ast_nationalitate (id_nationalitate, denumire) values (4, 'franceza');
insert into ast_nationalitate (id_nationalitate, denumire) values (5, 'romana');

insert into ast_fotomodel (id_fotomodel, id_nationalitate, nume, prenume, data_nasterii, salariu) values (20,3,'Rodriguez','Samantha',to_timestamp('01-jan-2000', 'dd-mon-rr hh.mi.ssxff am'), 17000);
insert into ast_fotomodel (id_fotomodel, id_nationalitate, nume, prenume, data_nasterii, salariu) values (21,1,'Smith','Bella',to_timestamp('15-oct-1995', 'dd-mon-rr hh.mi.ssxff am'),70000);
insert into ast_fotomodel (id_fotomodel, id_nationalitate, nume, prenume, data_nasterii, salariu) values (22,1,'Marshal','Martha',to_timestamp('27-jun-1999', 'dd-mon-rr hh.mi.ssxff am'),21000);
insert into ast_fotomodel (id_fotomodel, id_nationalitate, nume, prenume, data_nasterii, salariu) values (23,2,'Jones','Suellen',to_timestamp('09-apr-1997', 'dd-mon-rr hh.mi.ssxff am'),30000);
insert into ast_fotomodel (id_fotomodel, id_nationalitate, nume, prenume, data_nasterii, salariu) values (24,1,'Kennedy','Melanie',to_timestamp('20-mar-1991', 'dd-mon-rr hh.mi.ssxff am'),45000);
commit;

delete from ast_fotomodel;
insert into ast_defilare (id_defilare, id_eveniment, ora_inceput, ora_final) values (1,101,'13:20','13:50');
insert into ast_defilare (id_defilare, id_eveniment, ora_inceput, ora_final) values (2,105,'17:10','17:20');
insert into ast_defilare (id_defilare, id_eveniment, ora_inceput, ora_final) values (3,203,'11:00','11:15');
insert into ast_defilare (id_defilare, id_eveniment, ora_inceput, ora_final) values (4,304,'20:05','20:15');
insert into ast_defilare (id_defilare, id_eveniment, ora_inceput, ora_final) values (5,406,'18:50','19:00');

--ex 13 creeare secv
create sequence ast_seq_brand
increment by 100
start with 100
maxvalue 10000
nocycle;

insert into ast_brand (id_brand, denumire, sediu) values (ast_seq_brand.nextval,'Chanel','New York');
insert into ast_brand (id_brand, denumire, sediu) values (ast_seq_brand.nextval,'Dior','Boston');
insert into ast_brand (id_brand, denumire, sediu) values (ast_seq_brand.nextval,'Luis Vuitton','Paris');
insert into ast_brand (id_brand, denumire, sediu) values (ast_seq_brand.nextval,'Versace','Milano');
insert into ast_brand (id_brand, denumire, sediu) values (ast_seq_brand.nextval,'Prada','New Jersey');

create sequence ast_seq_colectii
increment by 1
start with 1
maxvalue 1000
nocycle;

insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,100,'toamna-iarna','Space theme');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,300,'primavara-vara','Escalator runway');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,100,'toamna-iarna','Grocery store');
insert into ast_colectii (id_colectie, id_brand, sezon) values (ast_seq_colectii.nextval,200,'primavara-vara');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,400,'primavara-vara','Underwater escapism');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,500,'toamna-iarna','New color');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,500,'primavara-vara','Indian style');
insert into ast_colectii (id_colectie, id_brand, sezon) values (ast_seq_colectii.nextval,300,'toamna-iarna');
insert into ast_colectii (id_colectie, id_brand, sezon, tematica) values (ast_seq_colectii.nextval,400,'toamna-iarna','Country side style');
insert into ast_colectii (id_colectie, id_brand, sezon) values (ast_seq_colectii.nextval,200,'primavara-vara');

create sequence ast_seq_tinute
increment by 1
start with 10
maxvalue 1000
nocycle;

insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 1,500,'casmir');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 1,180.0,'lana');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 7,2700,'voal');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 5,3000,'panza');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 2,1750,'matase');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 6,3600,'bumbac');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 9,9900,'piele');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 3,2000,'lana');
insert into ast_tinute (id_tinuta, id_colectie, pret, material) values (ast_seq_tinute.nextval, 5,5000,'in');

insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (101, 100,100);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (101, 300,100);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (203, 200,200);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (203, 300,200);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (105, 100,150);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (105, 500,150);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (304, 200,100);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (304, 400,100);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (406, 400,220);
insert into ast_ia_parte (id_eveniment, id_brand, taxa_participare) values (406, 500,220);

insert into ast_cumpara (id_participant, id_tinuta, marime) values (151,10,'S');
insert into ast_cumpara (id_participant, id_tinuta, marime) values (151,11,'S');
insert into ast_cumpara (id_participant, id_tinuta, marime, discount) values (207,17,'M',5);
insert into ast_cumpara (id_participant, id_tinuta, marime) values (306,16,'L');
insert into ast_cumpara (id_participant, id_tinuta, marime) values (306,12,'L');
insert into ast_cumpara (id_participant, id_tinuta, marime) values (306,10,'L');
insert into ast_cumpara (id_participant, id_tinuta, marime, discount) values (450,17,'XS',2);
insert into ast_cumpara (id_participant, id_tinuta, marime, discount) values (161,17,'M',2);
insert into ast_cumpara (id_participant, id_tinuta, marime) values (161,15,'M');
insert into ast_cumpara (id_participant, id_tinuta, marime) values (450,12,'S');
insert into ast_cumpara (id_participant, id_tinuta, marime) values (207,12,'XS');

insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (20,1,10,to_timestamp('04-aug-2017','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (21,1,11,to_timestamp('04-aug-2017','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (24,1,17,to_timestamp('05-aug-2017','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (22,3,12,to_timestamp('08-oct-2013','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (23,3,14,to_timestamp('09-oct-2013','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (20,2,15,to_timestamp('08-jul-2014','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (24,4,18,to_timestamp('07-nov-2015','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (20,4,16,to_timestamp('07-nov-2015','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (23,5,13,to_timestamp('25-jun-2016','dd-mon-rr hh.mi.ssxff am'));
insert into ast_prezinta (id_fotomodel, id_defilare, id_tinuta, data_prezentare) values (22,5,15,to_timestamp('18-jun-2016','dd-mon-rr hh.mi.ssxff am'));

commit;