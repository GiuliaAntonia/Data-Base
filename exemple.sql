--11. Formulați în limbaj natural și implementați 5 cereri SQL complexe

--1. Sa se afiseze tarile ordonate dupa nume in care a calatorit participantul cu id-ul 161 pentru a participa la prezentarile din fashion week
-- Se va folosi: subcerere nesincronizata + ordonare
select ast_tara.id_tara, ast_tara.denumire
from ast_tara
    where id_tara in(select id_tara
                     from ast_oras
                     where id_oras in(select id_oras
                                      from ast_fashionweek
                                      where id_evenimet in(select id_evenimet
                                                           from ast_participa
                                                           where ast_participa.id_eveniment = ast_fashionweek.id_evenimet and id_participant --= 161 and ast_participa.id_eveniment = ast_fashionweek.id_evenimet
                                                           in(select id_participant
                                                              from ast_participanti
                                                              where id_participant = 161)
                                                           )
                                     )
                     )
order by ast_tara.denumire;


--2.1. Pentru fiecare participant care contine 'ha' in prenume sa se afiseze suma totala a tinutele pe care le-a cumparat  si intr-o coloana 'status pret' sa se
-- afiseze un mesaj care indica statusul cheltuielilor (mic, 3000<mediu <5000, mare>=5000)
-- Se foloseste: clauza with + case + group by + ordonare
with pret as (select ast_cumpara.id_participant, sum(pret) as total
              from ast_tinute
                       join ast_cumpara on (ast_tinute.id_tinuta = ast_cumpara.id_tinuta)
                       join ast_participanti on (ast_cumpara.id_participant = ast_participanti.id_participant)
              where ast_participanti.prenume like ('%nd%')
              group by ast_cumpara.id_participant
              order by id_participant)

select id_participant, total,
       case when total > 5000 then 'Mare'
            when total < 5000 and total >=2000 then 'Mediu'
            else 'Mic'
end as "status cheltuieli"
from pret;

--2.2. Pentru fiecare fotomodel care contine 'ha' in prenume sa se afiseze suma totala a tinutele pe care le-a cumparat  si intr-o coloana 'status salarii' sa se
-- afiseze un mesaj care indica statusul cheltuielilor (mic, 20000<salariu mediu <50000, mare>=50000)
with salariu as(select id_fotomodel, salariu, prenume
                from ast_fotomodel
                where ast_fotomodel.prenume like ('%ha%')
                group by id_fotomodel, salariu, prenume
                order by id_fotomodel)
select id_fotomodel, salariu, prenume,
case when salariu >= 50000 then 'salariu mare'
    when salariu < 50000 and salariu >= 20000 then 'salariu mediu'
    else 'salariu mic'
end as "status salarii"
from salariu;


--3. Verificati daca un loc e rezervat si afisati intr-o 'Rezervat', respectiv 'Nerezervat' intr-o coloana denumita corespunzator (daca
-- disponibilitae = (null) => nu e rezervat
-- Se foloseste: decode + nvl
-- verf daca exisya o agentie cu doul 30 folosind DECODE
select id_loc,
decode(nvl(disponibilitate, 0), 1, 'Rezervat', 'Nerezervat') as rezervari
from ast_loc_vip;

--4. Pentru brandurile care contin tinute a caror pret maxim este >= 4500 si pretul mimim <= 3500 , sa se obtina id-ul, numele si pretul maxim si minim
-- al unei tinute a brandului respectiv
-- Se foloseste: grupari de date + functii grup(min, max) + filtrare la nivel de grup
select ast_brand.id_brand, denumire, max(pret) as "pret maxim", min(pret) as "pret minim"
from ast_brand join ast_colectii on (ast_brand.id_brand = ast_colectii.id_brand)
               join ast_tinute on (ast_colectii.id_colectie = ast_tinute.id_colectie)
group by ast_brand.id_brand, denumire
having max(pret) >= 4500 and min(pret) <= 3500;


--5. Sa se afiseze detalii despre fotomodelele care au participat la fashion-week-ul care contine 'style' in tematica si a avut loc mai acum mai bine
-- de 80 de luni si (fotomodelele) au prezentat tinute pt brandul care are sediu intr-un oras care contine 'New', cu numele si prenumele concatenat
-- as 'Nume'
-- Se foloseste: functie sir caracter
select ast_fotomodel.id_fotomodel, concat(ast_fotomodel.nume, ' ')||ast_fotomodel.prenume as "nume fotomodel"--, ast_colectii.tematica
from ast_fotomodel join ast_prezinta on (ast_fotomodel.id_fotomodel = ast_prezinta.id_fotomodel)
where ast_prezinta.id_defilare = 1;

select ast_fotomodel.id_fotomodel, concat(ast_fotomodel.nume, ' ')||ast_fotomodel.prenume as "nume fotomodel", ast_colectii.tematica,ast_fashionweek.id_evenimet, ast_brand.id_brand
from ast_fotomodel join ast_prezinta on (ast_fotomodel.id_fotomodel = ast_prezinta.id_fotomodel)
                   join ast_tinute on (ast_prezinta.id_tinuta = ast_tinute.id_tinuta)
                   join ast_colectii on (ast_tinute.id_colectie = ast_colectii.id_colectie)
                   join ast_brand on (ast_colectii.id_brand = ast_brand.id_brand)
                   join ast_ia_parte on (ast_brand.id_brand = ast_ia_parte.id_brand)
                   join ast_fashionweek on (ast_ia_parte.id_eveniment = ast_fashionweek.id_evenimet)
where ast_colectii.tematica like ('%style%') and ast_brand.sediu like ('%New%') and months_between(to_timestamp(sysdate,'dd-mon-rr'), data_sfarsit) > 80;


--12. Implementarea a 3 operatii de actualizare sau suprimare a datelor utilizand subcereri

--1. Sa se mareasca cu 10% pretul tinutelor expuse de brand-ul 'Chanel'
update ast_tinute
set pret = pret*1.1
where ast_tinute.id_colectie in(select ast_colectii.id_colectie
                   from ast_colectii
                   where ast_colectii.id_brand in (select ast_brand.id_brand
                                                      from ast_brand
                                                      where upper(ast_brand.denumire) = upper('Chanel'))
                   );
select * from ast_tinute;
rollback;

--2. Sa se majoreze cu 5% taxa de participare a brandului cu sediul in 'Paris'
update ast_ia_parte
set taxa_participare = taxa_participare*0.5
where ast_ia_parte.id_brand in (select ast_brand.id_brand
                                from ast_brand
                                where lower(ast_brand.sediu) = lower('Paris'));
select *from ast_ia_parte;
rollback;

--3. Sa se elimine tinutele care nu au un cumparator aferent
delete from ast_tinute
where ast_tinute.id_tinuta not in (select unique id_tinuta
                                   from ast_cumpara);
select * from ast_cumpara;
rollback ;

--ex 13 se afla in partea creeare_inserare la ex 10

--14. Crearea unei vizualizări compuse. Dați un exemplu de operație LMD permisă pe
-- vizualizarea respectivă și un exemplu de operație LMD nepermisă
create view ast_shopping_overview
as select ast_participanti.nume||' '||ast_participanti.prenume as "nume complet", ast_cumpara.marime, ast_tinute.pret, ast_tinute.material, ast_colectii.tematica
from ast_participanti inner join ast_cumpara on (ast_participanti.id_participant = ast_cumpara.id_participant)
                      inner join ast_tinute on (ast_cumpara.id_tinuta = ast_tinute.id_tinuta)
                      inner join ast_colectii on (ast_tinute.id_colectie = ast_colectii.id_colectie);
-- select este un exemplu de o comanda permisa pt o vizualizare compusa
select * from ast_shopping_overview;

-- comenziile LMD: insert/delete/update nu sunt pot fi aplicate direct pe vizualizarea compusa deoarece aceast e formata
-- prin join la mai multe tabele

--15. Crearea unui index care să optimizeze o cerere de tip căutare cu 2 criterii. Specificați cererea

--1. Sa se gaseasca fotomodelele cu prenumele 'Melanie' si salariu > 30000
-- folosim index pt optimizarea timpului de cautare
create index ast_prenume_salariu
on ast_fotomodel(prenume, salariu);

select prenume, salariu
from ast_fotomodel
where prenume = 'Melanie' and salariu > 3000;

--16. Formulati in limbaj natural si implementati in SQL: o cerere ce utilizeaza operatia outer-join pe minimum 4 tabele si doua
--cereri ce utilizeaza operatia division

--DEVISION
--1. Afisati toate fotomodelele care participa la aceleasi fashion week-uri  cu fotomodelul cu id-ul 22
-- si au pprezentat un nr egal de tinute
select ast_prezinta.id_fotomodel, nume||' '||prenume as "Nume complet"
from ast_prezinta join ast_fotomodel on (ast_prezinta.id_fotomodel = ast_fotomodel.id_fotomodel)
where id_defilare in (select id_defilare
                      from ast_prezinta
                      where ast_prezinta.id_fotomodel = 23)
and ast_prezinta.id_fotomodel != 23
group by ast_prezinta.id_fotomodel, nume, prenume
having count(*) = (select count(id_defilare)
                   from ast_prezinta
                   where ast_prezinta.id_fotomodel = 23);

--2. Afisati toti participantii care au cumparat aceleasi tinute cu participantul cu id-ul 207
select ast_cumpara.id_participant, nume||' '||prenume as "Nume complet"
from ast_cumpara join ast_participanti on (ast_cumpara.id_participant = ast_participanti.id_participant)
where id_tinuta in (select ast_cumpara.id_tinuta
                    from ast_cumpara
                    where ast_cumpara.id_participant = 207)
and ast_cumpara.id_participant != 207
group by ast_cumpara.id_participant, nume, prenume
having count(*) = (select count(id_tinuta)
                   from ast_cumpara
                   where ast_cumpara.id_participant = 207);

--OUTER JOIN
--1. Sa se afiseze numele, prenumele tuturor participantilor. Pt fiecare participant in parte se va afisa fashion week-ul
-- la care a participat dar si tinutele cumparate
select ast_participanti.nume, ast_participanti.prenume, ast_tinute.id_tinuta, ast_fashionweek.id_evenimet
from ast_participanti full outer join ast_participa on (ast_participanti.id_participant = ast_participa.id_participant)
                      full outer join ast_cumpara on (ast_participanti.id_participant = ast_cumpara.id_participant)
                      full outer join ast_tinute on (ast_cumpara.id_tinuta = ast_tinute.id_tinuta)
                      full outer join ast_fashionweek on (ast_participa.id_eveniment = ast_fashionweek.id_evenimet);