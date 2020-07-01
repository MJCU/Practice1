/*
req # 892561
FY20 Anniversary Data Requestithout an appeal code)
Please exclude:
•  Do Not Contact, Not Solicitable, Not Mail Solicitable, or Fall Spring Solicitation entities
•  Total FY Giving Amount less than $50 for FY15 (if that was their last year of giving)
•  Total FY Giving Amount less than $25 for FY16 (if that was their last year of giving)
•  Total FY Giving Amount less than $10 for FY17 (if that was their last year of giving)
•	 Donors who have made a gift since Feb 1, 2020.

Current donors
. All current donors who have made a gift in FY20 between $5 - $24,999

System
•  All active, mail solicitable donors, who have given within the past 5 FY, but not to their primary affiliation campus a gift between $5 and $24,999
o  For example, a Boulder alum who gives to Anschutz funds
 
Boulder
•         All active, mail solicitable donors who have given only to Boulder within the past 5 FY (FY15) a gift between $5 and $24,999
.         Please only provide Student Emergency Fund (0125072) as the first output fund for entities in this tab
 
Denver
•         All active, mail solicitable donors who have given only to Denver within the past 5 FY (FY15) a gift between $5 and $24,999
.         Please only provide Loving Lynx Emergency Fund (0321822) as the first output fund for entities in this tab
  
UCCS
•         All active, mail solicitable donors who have given only to UCCS within the past 5 FY (FY15) a gift between $5 and $24,999
.         Please only provide UCCS Community Support Scholarship Fund (0421665) as the first output fund for entities in this tab
 
AMC
•         All active donors who have given to AMC within the past 5 FY (FY15) a gift between $5 and $24,999
•  Include all current faculty and staff (exclude residents, interns and fellows)
•  Exclude grateful patients unless they have given to another campus, in which they would be on their respective campus tab
•  Please only provide University of Colorado Anschutz Shares (0223119) as the output fund for entities in this tab. 

Output
Please include last two gift dates for AMC, UCB, UCD and UCCS and the last three gift dates for System
(within the past 5 FY), gift amounts, allocation description (short name) and number

Please indicate in separate columns who is a current FY20 donor and who is a past donor.

•         Exclude anonymous gifts and active pledges
•         Exclude any gift tied to a proposal
•         Exclude non-deductible gifts to Boulder Athletics
•         Exclude alumni association memberships and license plate donations
•	Exclude speedtype gifts in output
•	Exclude donors with open pledges (excluding telephone pledges) or open proposals
•	Exclude past parents
•	Exclude foreign addresses

Include the allocation for the primary affiliation associated with each donor (attached spreadsheet) for Denver, Boulder, and System tabs. 

 
Each household should only receive one piece unless they don’t have joint giving 
or if one spouse has requested no spouse on label. 
Both spouses should receive the piece only addressed to them to prevent confusion. 

 
SUBSTITUTIONS AND EXCLUSIONS
·         For any gift or pledge payment made to Seniors Creating Future Buffs (0151077), substitute with Esteemed Scholars Fund (0125075)
·         Exclude gifts to memberships and alumni association memberships. 
·         Exclude those whose ONLY gift was to Boulder Athletics
          o   UCCS Athletics can be included 
·         Exclude anonymous gifts and pledge payments
·         Exclude if their ONLY gift is to a license plate fund
          o   0122509; 0221871; 0321445; 0421407
·         Exclude corporations and foundations not connected to an individual
·         Exclude gifts tied to a proposal
·         Exclude friends whose only gift is to Agency: HMO
·         Exclude friends who only gave through crowdfunding (FAXXXX, FBXXXX, FCXXXX, FDXXXX)
·         Exclude friends whose only giving is to 4TW
·         Exclude friends if their only giving is to Déjà vu Rendezvous (039329)
·       Exclude those with honorary degrees
·       Exclude friends who only made memorial gifts and gifts in honor of 
        o   Except for Giving Statement and Stewardship
·       Files should exclude friends who have only donated to crowdfunding projects (such as appeal code F00XX)
        o   Except for Giving Statement and Stewardship
·       Exclude grateful patients from all mailings
·       Exclude friends who only give to (0421326, 0421495, PhET funds 0125559, 0123893, 123247, 0123641, and Dan Barash 130793, 0150793)
 
 
RESPONSE DEVICE
· For the string of asks on the response device, please provide the largest gift in either FY18/FY19 to any designation 
  (excluding Boulder athletics and alumni association memberships/license plate funds). Should only include gifts and pledge payments
  o   Please remove the Parent Fund from the allocation string for past parents
· Please include the fund number and the long fund name. Please work top to bottom- no duplication of funds on the response device 
  o   Most recent gifts (3) made in FY18/FY19 
  o   Primary affiliation allocation (funds spreadsheet attached)
  o   Spouse primary affiliation allocation
  o   Fund for Excellence Funds (for their campus)
      §  Follow the campus that they gave to
      §  For Parents of two students on two different campuses (even if the parent only gave to one campus), 
         include both Parent Funds AND Fund for Excellence funds
o   Other
 

04/15/2020 MJJ Started

*/
select * from  tms_record_type; select * from allocation where allocation_code = '0854027';
select * from tms_transaction_type;
select * from gift g where g.gift_transaction_type = 'YC' order by gift_date_of_record desc;
drop table req_750935_alloc;
create table req_750935_alloc (
  alloc      varchar2(10),
  sub_alloc  varchar2(10));

delete from req_750935_alloc;  
select * from req_750935_alloc for update; commit;

-- ****************************    
DROP TABLE req_123307;
CREATE TABLE req_123307 AS
SELECT DISTINCT 
       e.primary_hh_entity_ind household,
       a.donor_id,
       e.spouse_id_number   spouse_id,
       ' ' fr_flag_crowdfunding,
       case when nvl(e.bus_pref_addr_ind,' ') = 'Y' then 'Y' else 'N' end bus_ind,
       e.nsp_ind            no_spouse_on_label,
       e.record_type_code   record_type,
       a.receipt_number, 
       a.pledge_number, 
       a.transaction_type,
       a.associated_code, 
       al.agency,
       a.year_of_giving, 
       a.date_of_record, 
       CASE WHEN a.campus = '9' THEN '8' ELSE a.campus END campus,
       al.alloc_school    school,
       a.dept,
       a.appeal_code, 
       al.status_code     alloc_status,
       a.alloc, 
       al.long_name     alloc_desc,
       a.proposal_id,
       CASE WHEN a.soft_credit > 0 THEN a.soft_credit ELSE a.legal_amt END soft_credit,
       e.line1  
-- select distinct  transaction_type, trans_type_desc -- select distinct a.associated_code -- 
-- select distinct a.record_type_desc, a.record_type_code
-- select *  -- select distinct a.campus
FROM   cuf_reporting_gift_detail a
         join cuf_reporting_entity e  on  a.donor_id       = e.id_number
         join primary_gift pg         on  a.receipt_number = pg.prim_gift_receipt_number
         join allocation al           on  a.alloc          = al.allocation_code
WHERE  e.record_status_code = 'A'
and    e.record_type_code not in ('TL')
and    e.person_or_org    = 'P'
and    a.year_of_giving in ('2015','2016','2017','2018','2019', '2020')
--and    to_char(a.date_of_record, 'YYYYMMDD') between '20180901' and '20181231'
AND    a.donor_id <> '0000044408'  -- not include anonymous gift
and    nvl(a.anonymous_code,' ') <> 'Y'
AND    (a.legal_amt > 0 OR a.soft_credit > 0)
AND    (NVL(a.pledge_number,' ') = ' ' 
        OR (NVL(a.pledge_number,' ') <> ' '
            AND NOT EXISTS (SELECT *
                            FROM   primary_pledge b
                            WHERE  b.prim_pledge_number = a.pledge_number
                            AND    (b.prim_pledge_amount > 24999 OR NVL(b.proposal_id,0) <> 0))))
AND    a.transaction_type IN ('GC','GF', 'PP')
and    pg.prim_gift_amount  < 25000
and    pg.prim_gift_amount >= 5
and    a.alloc not like '09%'
--and    a.alloc not in (select alloc from req_750935_alloc alloc where lower(alloc.sub_alloc) = 'exclude' )
;

insert into req_123307 
select e.primary_hh_entity_ind, a.spouse_id, a.donor_id,
       a.fr_flag_crowdfunding,
       case when nvl(e.bus_pref_addr_ind,' ') = 'Y' then 'Y' else 'N' end bus_ind,
       e.nsp_ind            no_spouse_on_label,
       e.record_type_code   record_type,
       a.receipt_number, 
       a.pledge_number, 
       a.transaction_type,
       'K', 
       a.agency,
       a.year_of_giving, 
       a.date_of_record, 
       a.campus,
       a.school,
       a.dept,
       a.appeal_code, 
       a.alloc_status,
       a.alloc, 
       a.alloc_desc,
       a.proposal_id,
       a.soft_credit,
       e.line1  
from   req_123307 a
         join cuf_reporting_entity e  on  a.spouse_id       = e.id_number
where  nvl(a.spouse_id,' ') <> ' '
and    exists (select * from req_123307 b where b.donor_id = a.spouse_id)
and    not exists (select *
                   from   req_123307 c
                   where  c.donor_id  = a.spouse_id
                   and    c.receipt_number = a.receipt_number
                   and    c.alloc          = a.alloc);
commit;                   

CREATE INDEX req_123307id_key0 ON req_123307(donor_id);
CREATE INDEX req_123307id_key1 ON req_123307(receipt_number);
CREATE INDEX req_123307id_key2 ON req_123307(Pledge_Number);

-- select distinct transaction_type from cuf_reporting_trans_detail where year_of_giving = '2020'
-- remove gving in FY20
/*delete -- select *
from  req_123307 a
where a.donor_id in (with tmp_id as (
                       select distinct donor_id, donor_id donor_id_2 from req_123307 
                       UNION
                       select distinct donor_id, spouse_id from req_123307 where nvl(spouse_id,' ') <> ' ' )
                     select distinct t.donor_id
                     from   tmp_id t,
                            cuf_reporting_trans_detail d 
                     where  t.donor_id_2 = d.original_donor_id
                     and    d.soft_credit_amt > 0
                     and    d.transaction_type <> 'MG'
                     and    to_char(d.date_of_record, 'YYYYMMDD') >= '20200701')   ;   
commit;           
*/

delete -- select *
from  req_123307 a
where a.donor_id in (with tmp_id as (
                       select distinct donor_id, donor_id donor_id_2 from req_123307 
                       UNION
                       select distinct donor_id, spouse_id from req_123307 where nvl(spouse_id,' ') <> ' ' )
                     select distinct t.donor_id
                     from   tmp_id t,
                            primary_pledge pp,
                            pledge         p 
                     where  pp.prim_pledge_status = 'A'
                     and    pp.prim_pledge_type not in ('BC','BE','TP')
                     and    pp.prim_pledge_number = p.pledge_pledge_number
                     and    p.pledge_donor_id = t.donor_id_2 ) ;   
commit;                                     


-- remove students households
delete -- select *
from   req_123307 a
where  a.donor_id in (with tmp_id as (
                       select distinct donor_id, donor_id donor_id_2 from req_123307 
                       UNION
                       select distinct donor_id, spouse_id from req_123307 where nvl(spouse_id,' ') <> ' ' )
                      select distinct t.donor_id
                      from   tmp_id t,
                             entity_record_type b 
                      where  t.donor_id_2 = b.id_number
                      and    b.record_type_code = 'ST' )   ; 
               
delete -- select *
from   req_123307 a
where  a.donor_id in (with tmp_id as (
                       select distinct donor_id, donor_id donor_id_2 from req_123307 
                       UNION
                       select distinct donor_id, spouse_id from req_123307 where nvl(spouse_id,' ') <> ' ' )
                      select distinct t.donor_id
                      from   tmp_id t,
                             entity b 
                      where  t.donor_id_2 = b.id_number
                      and    b.record_type_code = 'HA' )   ;            
commit;   

-- remove gift in kind and speedtype     
DELETE -- select distinct alloc, alloc_desc
FROM    req_123307 a
WHERE   NVL(alloc,' ') <> ' ' 
AND     (LENGTH(nvl(alloc,' ')) <> 7
         OR LENGTH(TRIM(TRANSLATE(alloc,'0123456789',' '))) IS NOT NULL);
commit; 

-- drop suspense account
DELETE -- select *
FROM   req_123307 a
WHERE  alloc IN (SELECT allocation_code -- select *
                 FROM   allocation al
                 WHERE  lower(al.short_name) LIKE '%suspense%');
commit;                              
               
-- move fund
UPDATE req_123307 a
SET    a.alloc = '0125075'
WHERE  a.alloc = '0151077'; 
commit;

-- substitute allocation
update req_123307 a
set    a.alloc = (select sub_alloc from req_750935_alloc alloc where alloc.alloc = a.alloc)
-- select * from req_123307 a
where  a.alloc in (select alloc from req_750935_alloc alloc/* where lower(alloc.sub_alloc) <> 'exclude'*/ );
commit;

/*
select * from req_750935_alloc
order by alloc
where alloc in ('0123624','0123625');
select *
from   req_123307 a
where  a.alloc in (select alloc from req_750935_alloc alloc );
*/


-- drop those who only gave to membership, UCB Athletics, or license plate
delete -- select * -- select distinct alloc, alloc_desc
from   req_123307 a
where  lower(a.alloc_desc) LIKE '%membership%' ;

-- remove those who only give to UCB Athletics or License Plates
delete -- select *
from   req_123307 a
where  (a.campus = '1' and a.school = 'AT');

delete -- select * -- select distinct alloc, alloc_desc
from   req_123307 a
where  lower(a.alloc_desc) like '%license plate%' ;
commit; 
        
-- drop proposal gift        
DELETE -- select *
FROM   req_123307 a
WHERE  EXISTS (SELECT *
               FROM   primary_gift pg
               WHERE  pg.prim_gift_receipt_number = a.receipt_number
               AND    (NVL(pg.proposal_id,0) <> 0));
COMMIT;

DELETE 
FROM  req_123307 a                  
WHERE  NVL(a.pledge_number,' ') <> ' '
AND    EXISTS (SELECT *
               FROM   primary_pledge pp
               WHERE  pp.prim_pledge_number = a.pledge_number
               AND    (NVL(pp.proposal_id,0) <> 0));    
COMMIT;  
 
-- remove friends who only gave to HMO
update req_123307 a
set    agency = 'HMO'
where  nvl(agency,' ') = ' '
and    exists (select *
               from   cuf_reporting_gift_detail b
                WHERE  b.receipt_number = a.receipt_number
                AND    b.associated_code IN ('H','M'));
commit;   

-- select * from req_123307 a where a.dept = '4TW'

-- remove friends who only gave to 4TW 
-- remove friends who only gave to Crowdfunding
-- remove friends who only gave to PhET funds (0125559, 0123893, 0123247, 0123641)
-- remove friends who only gave to Deja vu fund (0329329, 0329328) 
-- select * from allocation where lower(long_name) like 'deja vu%'
delete -- select distinct alloc, appeal_code, agency, dept
from   req_123307 a
where  a.record_type = 'FR'
and    (a.alloc in ('0125559', '0123893', '0123247', '0123641','0421326','0421495','0130793', '0150793')
        --or lower(a.alloc_desc) like 'deja vu%'
        /*or nvl(a.appeal_code,' ') like 'F%'
        or a.dept = '4TW'*/
        or nvl(a.agency,' ') <> ' ' )
and    not exists (select *
                   from   req_123307 b
                   where  b.donor_id = a.donor_id
                   and    b.alloc not in ('0125559', '0123893', '0123247', '0123641','0421326','0421495','0130793', '0150793')
                   --and    lower(b.alloc_desc) not like 'deja vu%'
                   /*and    nvl(b.appeal_code,' ') not like 'F%'*/
                   and    nvl(b.agency,' ') = ' '
                   /*and    nvl(b.dept,' ') <> '4TW'*/);
                   

update req_123307 a
set    a.fr_flag_crowdfunding = 'Y'
where  a.record_type = 'FR'
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  nvl(b.appeal_code,' ') like 'F%')
                      , tmp_not as (
                        select distinct donor_id
                        from   req_123307 b
                        where  nvl(b.appeal_code,' ') not like 'F%')        
                      select c.donor_id
                      from  tmp_in c
                            left join tmp_not d  ON c.donor_id = d.donor_id
                      where d.donor_id is null ) ;                    
commit; 


/*
select * from appeal_header where appeal_code like 'F%'
select * 
from   req_123307 a 
where  donor_id in (select distinct donor_id from req_123307 where a.fr_flag_crowdfunding = 'Y')
order by donor_id ;

select *
from   req_123307 a
where  ( nvl(a.appeal_code,' ') like 'F%'
        or a.dept = '4TW')
and    record_type = 'FR'        
*/

--	Exclude Anschutz Friends
delete -- select *  -- select distinct campus
from   req_123307 a
where  a.record_type = 'FR'
and    a.donor_id in (with tmp_at as (
                        select distinct donor_id 
                        from   req_123307 a
                        where  a.campus = '2')
                     , tmp_not_at as (
                        select distinct donor_id 
                        from   req_123307 a
                        where  not(campus = '2') )  
                     select a.donor_id
                     from   tmp_at a
                              left join tmp_not_at b  ON  a.donor_id = b.donor_id
                     where  nvl(b.donor_id,' ') = ' '  );     
commit; 

-- exclude past parent
delete -- select *
from   req_123307 a
where  a.donor_id in (with tmp_past_parent as (
                        select distinct id_number
                        from   affiliation af
                        where  af.affil_level_code = 'PR'
                        and    af.affil_status_code in ('P','N') )
                      ,tmp_not_past_parent as (
                         select distinct id_number
                         from   affiliation af
                         where  not (af.affil_level_code = 'PR'
                                     and    af.affil_status_code in ('P','N')) )
                      select a.id_number
                      from   tmp_past_parent a
                               left join tmp_not_past_parent b  ON a.id_number = b.id_number
                      where  b.id_number is null)  
and   donor_id not in (select distinct donor_id
                       from   req_123307 b
                       where  year_of_giving = '2020' ) ;  
commit;                                                                

-- select * from affiliation where id_number = '0000478503'
/*
delete -- select *
from   req_123307 a
where  a.record_type not in ('AL', 'AN', 'ND')
and    a.donor_id  in (select distinct id_number
                      from   affiliation af
                      where  af.affil_code in ('1','2','3','4')
                      and    af.affil_level_code = 'PR'  
                      and    af.affil_status_code  ='P'   
                      and    af.id_number not in (select distinct id_number
                                                  from   affiliation af1 
                                                  where  af1.affil_code in ('1','2','3','4')
                                                  and    af1.affil_level_code = 'PR'  
                                                  and    af1.affil_status_code  ='C'   ));*/
                                                  /*UNION
                                                  select distinct id_number
                                                  from   affiliation af2 ,
                                                         ag_alloc_map_table b 
                                                  where  af2.record_type_code in ('AL','AN','ND')        
                                                  and    af2.affil_primary_ind = 'Y'
                                                  AND    af2.affil_status_code IN ('F','G','N','U')
                                                  and    case when af2.affil_code = '8' 
                                                              then '3' 
                                                              else af2.affil_code end || af2.affil_level_code = b.affil ) );*/


-- remove by amount
DELETE 
from   req_123307 a
-- select * from req_123307 a
WHERE  a.donor_id IN (SELECT b.donor_id -- select * 
                      FROM   req_123307 b
                      where  b.soft_credit > 24999);
commit;                      
                      
-- select * from req_123307 where  receipt_number = '0002567785' and donor_id = '0000586038' 
DELETE -- select *
from   req_123307 a
-- select * from req_123307 a
WHERE  a.donor_id IN (SELECT b.donor_id -- select * 
                      FROM   req_123307 b
                      group by donor_id
                      having  sum(b.soft_credit) < 5);
commit;                                                              

-- remove not AL, FR, or PA -- should be done later
/*delete -- select distinct record_type
from   req_123307 a
where  record_type not in ('AL','FR','PA','AN','ND') ;*/

-- re-calculate primary households
update req_123307 a
set    household = cuf_is_primary_hh_entity(a.donor_id)
-- select * from req_123307 a
where  nvl(spouse_id,' ') <> ' '
and    exists (select *
               from   req_123307 b
               where  b.donor_id = a.spouse_id
               and    b.household = a.household);
commit; 

update req_123307 a
set    a.household = 'Y'
where  a.household = 'N'
and    nvl(a.spouse_id,' ') not in (select distinct donor_id from req_123307) ;
commit;

drop table req_123307_save;
create table req_123307_save as
--select distinct donor_id, spouse_id, record_type, household, bus_ind, no_spouse_on_label, line1 
select *
from   req_123307 a
where  nvl(spouse_id,' ') <> ' '
and    a.household = 'N'
and    spouse_id in (select distinct donor_id from req_123307);               

-- households and then remove those should not be
-- households
delete -- select *
from   req_123307 a
where  nvl(spouse_id,' ') <> ' '
and    a.household = 'N'
and    exists (select *
               from   req_123307 b
               where  b.donor_id = a.spouse_id
               and    b.household = 'Y'
               and    b.receipt_number = a.receipt_number
               and    b.alloc          = a.alloc);
commit;   

-- insert spouse back 
insert into req_123307 a
select distinct a.*
       -- select * 
from   req_123307_save a,
       req_123307 b
where  nvl(b.spouse_id,' ') <> ' '
and    b.spouse_id = a.donor_id   
and    a.record_type <> 'FR' 
/*and    (a.no_spouse_on_label = 'Y' OR a.bus_ind = 'Y')*/
--and    a.donor_id not in (select donor_id from req_123307)
/*and    a.donor_id in ('0000410413','0000463086')*/
order by a.donor_id  ;
commit; 

/* 
select * from req_123307 where donor_id in ('0000015135', '0000459333') ;
select * from req_123307 where donor_id in ('0000024621', '0000275411') ;
select * from req_123307 where donor_id in ('0000035217', '0000277158') ;
*/            

-- drop pref address as foreign
DELETE -- select *
FROM   req_123307 a
WHERE  EXISTS (SELECT *
               FROM   cuf_reporting_entity b
               WHERE  b.id_number = a.donor_id
               AND    nvl(b.country_desc,' ') <> ' ');
               
DELETE -- select *
FROM   req_123307 a
WHERE  EXISTS (SELECT *
               FROM   cuf_reporting_entity b
               WHERE  b.id_number = a.donor_id 
               AND    b.noc_ind = 'Y') ;
 
-- select * from tms_handling_type              
delete -- select *
from   req_123307 a
where  a.donor_id in (with tmp_in as (
                        select distinct id_number
                        from   handling h
                        WHERE  h.hnd_status_code = 'A'
                        AND    h.hnd_type_code IN ('NML','NMS','NOC','NOS', 'FSO') )
                      , tmp_not_in as (
                        select  distinct id_number
                        from   handling h
                        WHERE  h.hnd_status_code = 'A'
                        and    h.hnd_type_code IN ('SSO'))
                     select a.id_number
                     from   tmp_in a
                              left join tmp_not_in b  ON  a.id_number = b.id_number
                     where  nvl(b.id_number,' ') = ' ' ) ;
commit;  

delete -- select *
from   req_123307 a
where  nvl(a.line1,' ') = ' ';      
commit;


-- households one more time
delete -- select * -- select distinct record_type
from   req_123307 a 
where  nvl(spouse_id,' ') <> ' '
and    (a.bus_ind = 'Y' or a.no_spouse_on_label = 'Y')
and    exists (select *
               from   req_123307 b
               where  b.donor_id = a.spouse_id
               and    b.bus_ind = 'N' 
               and    b.no_spouse_on_label = 'N');   

delete -- select * -- select distinct record_type
from   req_123307 a 
where  nvl(spouse_id,' ') <> ' '
and    a.household = 'N'
and    exists (select *
               from   req_123307 b
               where  b.donor_id = a.spouse_id
               and    b.household = 'Y'
               and    b.bus_ind = 'N' 
               and    b.no_spouse_on_label = 'N');                       
commit;  

                                                            

update req_123307 a
set    a.alloc_status = (select al.status_code from allocation al where al.allocation_code = a.alloc );
commit;

-- move inactive fund
drop table req_123307_alloc;
create table req_123307_alloc as
with tmp as (
  select distinct alloc, alloc_desc, 
         regexp_substr(al.xcomment,'(\d)(\d)(\d)(\d)(\d)(\d)(\d)') allocation_code ,
         al.xcomment
  from   req_123307 a ,
         allocation al
  where  alloc_status <> 'A'
  and    a.alloc = al.allocation_code
  order by alloc)
  select a.alloc, al.allocation_code, al.long_name long_name
  from   tmp a,
         allocation al 
  where  nvl(a.allocation_code,' ') = al.allocation_code  
  and    al.status_code = 'A' ; 
  
-- select * from req_123307_alloc   
-- select * from allocation where allocation_code = '0421502' 

update req_123307 a
set    (a.alloc, a.alloc_desc, a.alloc_status) = (select allocation_code, b.long_name, 'A'
                                                  from   req_123307_alloc b
                                                  where  b.alloc = a.alloc  )
-- select * from req_123307 a
where  a.alloc_status <> 'A'
and    exists (select *
               from   req_123307_alloc b 
               where  b.alloc = a.alloc );
commit;

drop table req_123307_save_id;
create table req_123307_save_id as
select * from req_123307;

delete -- select *
from   req_123307
where  alloc_status <> 'A';
commit;

update req_123307 a
set    a.campus = '3'
-- select * from req_123307 a
where  a.alloc  = '0854027';
commit;

delete -- select *
from   req_123307 a 
where  a.donor_id in (with tmp_id as (
                        select donor_id, year_of_giving, sum(soft_credit) soft_credit
                        from   req_123307 b
                        group by donor_id, year_of_giving )
                      , tmp_id2 as (
                        select donor_id, max(year_of_giving) fy
                        from   tmp_id b
                        group by donor_id  )
                      , tmp_id3 as (
                        select a.donor_id, b.fy, a.soft_credit 
                        from   tmp_id a,
                               tmp_id2 b
                        where  a.donor_id = b.donor_id
                        and    a.year_of_giving = b.fy )     
                      select donor_id
                      from   tmp_id3 
                      where  (fy = '2015' and soft_credit < 50)
                      OR     (fy = '2016' and soft_credit < 25)   
                      or     (fy = '2017' and soft_credit < 10)   )
/*order by donor_id, year_of_giving                     */ ;
COMMIT;                      

/*
select * -- select distinct alloc_status
from req_123307 a order by donor_id
*/


-- assign campus
alter table req_123307 add gift_campus varchar2(1);
/*            
select * from req_123307 order by donor_id, year_of_giving desc;
*/

update req_123307 a
set    a.gift_campus = '0'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (select distinct donor_id -- select *
                      from   req_123307 b
                      where  year_of_giving = '2020');

update req_123307 a
set    a.gift_campus = '1'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus = '1')
                      , tmp_not_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus <> '1')
                      select a.donor_id
                      from   tmp_in a
                               left join tmp_not_in b  ON  a.donor_id = b.donor_id
                      where  b.donor_id is null );            
                      
update req_123307 a
set    a.gift_campus = '2'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus = '2')
                      , tmp_not_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus <> '2')
                      select a.donor_id
                      from   tmp_in a
                               left join tmp_not_in b  ON  a.donor_id = b.donor_id
                      where  b.donor_id is null );                      
                      
update req_123307 a
set    a.gift_campus = '3'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus = '3')
                      , tmp_not_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus <> '3')
                      select a.donor_id
                      from   tmp_in a
                               left join tmp_not_in b  ON  a.donor_id = b.donor_id
                      where  b.donor_id is null );                 
                      
update req_123307 a
set    a.gift_campus = '4'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus = '4')
                      , tmp_not_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus <> '4')
                      select a.donor_id
                      from   tmp_in a
                               left join tmp_not_in b  ON  a.donor_id = b.donor_id
                      where  b.donor_id is null );                
                      
update req_123307 a
set    a.gift_campus = '8'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (with tmp_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus = '8')
                      , tmp_not_in as (
                        select distinct donor_id
                        from   req_123307 b
                        where  b.campus <> '8')
                      select a.donor_id
                      from   tmp_in a
                               left join tmp_not_in b  ON  a.donor_id = b.donor_id
                      where  b.donor_id is null );                
                      
update req_123307 a
set    a.gift_campus = '8'
where  nvl(a.gift_campus,' ') = ' '
and    a.donor_id in (select distinct donor_id
                      from   req_123307 b
                      where  1 < (select count(distinct campus)
                                  from   req_123307 c
                                  where  c.donor_id = b.donor_id));
commit;   
/*
select * -- select distinct gift_campus
 from req_123307 a 
where  nvl(gift_campus,' ') = '0'
order by donor_id, year_of_giving desc;
*/

delete -- select *
from   req_123307 a
where  nvl(a.gift_campus,' ') = ' ';
commit; 

delete -- select *
from   req_123307 a
where  a.gift_campus = '2'
and    a.record_type = 'FR' ;

/*delete -- select distinct record_type -- select distinct gift_campus
from    req_123307 a
where   a.gift_campus <> '2'
and     record_type not in ('AL','FR','PA','AN','ND');*/

/*delete -- select distinct record_type -- select distinct gift_campus
from    req_123307 a
where   a.gift_campus = '2'
and     record_type not in ('AL','PA','AN','ND', 'FC', 'SF');*/

delete -- select *
from   req_123307 a
where  a.gift_campus = '2'
and    a.record_type = 'FC'
and    a.donor_id in (select distinct id_number
                      from   degrees d
                      where  local_ind = 'Y'
                      and    campus_code = '2'
                      and    school_code = 'MD'
                      and    (degree_code in ('R','I','F')
                              OR non_grad_code in ('R','I','F'))) ;

commit;

-- most recent gift
DROP TABLE   req_123307_recent_gift;
CREATE TABLE req_123307_recent_gift AS
with tmp_id_2 as (
  select b.donor_id id_number,
         b.campus,
         b.alloc,
         b.alloc_desc,
         date_of_record,
         sum(soft_credit)   soft_credit
  FROM   req_123307 b
  GROUP BY b.donor_id, b.campus, b.alloc, b.alloc_desc, date_of_record )
, tmp_id AS (
  SELECT a.id_number,
         a.campus,
         a.alloc,
         a.alloc_desc,
         a.date_of_record,
         soft_credit,
         rank() over(partition by id_number 
                     order by a.date_of_record desc,
                              soft_credit desc,a.campus, a.alloc) seq
  FROM   tmp_id_2 a )
select *
from   tmp_id 
order by id_number, seq ; 

delete -- select *
from   req_123307_recent_gift a
where  exists (select *
               from   req_123307_recent_gift b
               where  b.id_number = a.id_number
               and    b.seq       < a.seq
               and    b.alloc     = a.alloc);
commit;              

/*
select *
from   req_123307_recent_gift a
order by id_number, date_of_record desc
*/

-- treat past parent (only affiliation) as friend
drop table req_123307_affil;
create table req_123307_affil as 
with tmp_id as (
  select distinct donor_id id_number, donor_id id_number_2 from req_123307 
  UNION
  select distinct donor_id, spouse_id from req_123307 where nvl(spouse_id,' ') <> ' '  )
, tmp_primary_affil as (
  select a.id_number,
         case when a.id_number = af.id_number then 1 else 2 end seq, 
         case when af.affil_code = '8' then '3' else af.affil_code end || af.affil_level_code affil_level  
   from  tmp_id a
           JOIN  affiliation af ON  a.id_number_2 = af.id_number  
   where af.record_type_code in ('AL','AN','ND')        
   and   af.affil_primary_ind = 'Y'
   AND   af.affil_status_code IN ('F','G','N','U')
   and   exists (select *
                 from   ag_alloc_map_table b
                 where  case when af.affil_code = '8' then '3' else af.affil_code end || af.affil_level_code = b.affil)  )
, tmp_c_parent_affil as (  
  select distinct a.id_number, 3 seq, 
                  af.affil_code  || af.affil_level_code  current_pr 
   from  tmp_id a
           JOIN  affiliation af ON  a.id_number_2 = af.id_number  
   where af.affil_code in ('1','2','3','4')
   and   af.affil_level_code = 'PR'  
   and   af.affil_status_code  ='C'  )                 
, tmp_p_parent_affil as (  
  select distinct a.id_number, 4 seq, af.affil_code  || af.affil_level_code  current_pr 
   from  tmp_id a
           JOIN  affiliation af ON  a.id_number_2 = af.id_number  
   where af.affil_code in ('1','2','3','4')
   and   af.affil_level_code = 'PR'  
   and   af.affil_status_code  ='P'
   and   not exists (select *
                     from   affiliation af2 
                     where  af2.id_number = a.id_number_2
                     and    af2.affil_level_code = af.affil_level_code
                     and    af2.affil_code       = af.affil_code
                     and    af2.affil_status_code = 'C'  ) ) 
select * from tmp_primary_affil 
UNION
select * from tmp_c_parent_affil 
order by 1,2;  

/*
with tmp as (
select id_number from req_123307_affil where affil_level like '%PR')
select distinct af.affil_status_code
from   tmp a
        left join affiliation af   ON  a.id_number = af.id_number 
                                   and af.affil_level_code = 'PR';
select * from affiliation where id_number = '0000423412';
*/

-- select * from req_123307_affil where id_number = '0000004817'         

delete -- select *
from   req_123307_affil a
where  exists (select * 
               from   req_123307_affil b
               where  b.id_number = a.id_number
               and    b.seq       < a.seq
               and    b.affil_level = a.affil_level );    
commit; 

delete -- select *
from   req_123307 a
where  not exists (select * 
                   from   req_123307_recent_gift b 
                   where  b.id_number = a.donor_id and b.alloc = a.alloc) ;
commit;

/*
select * from req_123307_affil a order by id_number, seq
select * from allocation where allocation_code = '0223119';
select * from allocation where allocation_code = '0421665';
select *
from   ag_alloc_map_table
where  affil = '2a'
order by affil for update; commit;

select *
from   ag_alloc_map_table
where  affil like '4a'
order by affil for update; commit;

select *
from   ag_alloc_map_table
where  affil in ('2a','4a');
select * from allocation where allocation_code = '0321822'
select * from ag_alloc_map_table order by affil for update; commit;
*/
   

drop table req_123307_alloc;
create table req_123307_alloc as
with tmp1 as (
  select distinct gift_campus, donor_id id_number from req_123307 )   
, tmp_campus_fund as (
  select distinct a.gift_campus, a.id_number, 1 seq, b.affil, b.alloc, fund_name
  from   tmp1 a
           join ag_alloc_map_table b  ON  a.gift_campus = substr(b.affil,1,1) 
  where  substr(b.affil,2,2) in ('a','b')    )
, tmp2_affil as (
  select distinct a.gift_campus, a.id_number, 2, c.affil, c.alloc, fund_name
  from   tmp1 a
           join  req_123307_affil b   ON  a.id_number = b.id_number  
           join  ag_alloc_map_table c ON  substr(b.affil_level,1,1) = substr(c.affil,1,1) 
  where  substr(c.affil,2,2) in ('a','b')    )    
, tmp3_affil as (
  select distinct a.gift_campus, a.id_number, 3 + b.seq, c.affil, c.alloc, fund_name
  from   tmp1 a
           join  req_123307_affil b   ON  a.id_number = b.id_number   
           join  ag_alloc_map_table c ON  b.affil_level = c.affil   
  where  b.seq <> 4  )
select * from   tmp_campus_fund
UNION
select * from   tmp2_affil
UNION
select * from   tmp3_affil       
order by 2,3,1 ;       

delete -- select *
from   req_123307_alloc a /*where id_number = '0000000411'*/
where  exists (select *
               from   req_123307_alloc b 
               where  b.id_number = a.id_number
               and    b.seq       < a.seq
               and    b.affil     = a.affil);       
commit; 

delete -- select *
from   req_123307_alloc a
where  exists (with tmp_gift as (
                  select id_number, alloc, alloc_desc, date_of_record, soft_credit,
                         rank() over(partition by id_number order by seq) seq
                  from   req_123307_recent_gift )
               select *
               from   tmp_gift b
               where  b.seq <= 3
               and    b.id_number = a.id_number
               and    b.alloc     = a.alloc ) ;
commit;    
/*
select *
from   req_123307_alloc a
where  gift_campus = '0'
order by id_number, seq
*/           


DROP TABLE req_123307_set;
CREATE TABLE req_123307_set AS
WITH tmp_largest_gift AS (
  SELECT gift_campus,
         donor_id id_number, 
         fr_flag_crowdfunding,
         alloc,
         alloc_desc,
         rank() over(partition by donor_id order by soft_credit desc, date_of_record desc, alloc ) seq,
         a.soft_credit 
  -- select *
  FROM   req_123307 a
  order by 1,6 )
  --select distinct fr_flag_crowdfunding from tmp_largest_gift
, tmp_gift as (
  select id_number, alloc, alloc_desc, date_of_record, soft_credit,
         rank() over(partition by id_number order by seq) seq
  from   req_123307_recent_gift 
  order by 1, 6       )   
/*, tmp_gift_date as (
  select * from req_123307 a where a.gift_date_flag = 'Y' )*/
, tmp_affil_alloc as (
  select id_number, affil, alloc, fund_name,
         rank() over(partition by id_number order by seq, affil) seq
  from   req_123307_alloc a
  /*where  id_number = '0000240942'*/
  order by 1,  5 )
, tmp_affil as (
  select id_number,
         seq, 
         affil_level,
         rank() over(partition by id_number, seq order by affil_level) new_seq
  from   req_123307_affil 
 /* where  id_number = '0000240942'*/
  order by 1,4 ) 
/*select max(new_seq) from tmp_affil  */
/*select max(seq) from  tmp_affil_alloc*/
SELECT distinct 
       a.gift_campus,
       CASE WHEN a.gift_campus = '0' THEN 'Current_Donor'
            WHEN a.gift_campus = '1' THEN 'UCB'
            WHEN a.gift_campus = '2' THEN 'AMC'
            WHEN a.gift_campus = '3' THEN 'UCD'
            WHEN a.gift_campus = '4' THEN 'UCCS'
            WHEN a.gift_campus = '8' THEN 'System'
       END                                        campus_desc,
       cuf_get_handling(a.id_number)              special_handling,
       en.a1_ind                                  anonymous,
       en.noc_ind                                 no_contact_at_all,
       en.mail_solicitable_ind                    mail_solicitable,
       en.nsp_ind                                 no_spouse_on_label,
       case when en.prospect_manager = 'NONE' then ' ' else en.prospect_manager end prospect_manager,
       en.record_type_code                        record_type,
       en.record_type_desc                        record_type_desc,
       en.record_status_desc                      record_status,
       a.fr_flag_crowdfunding                     Friend_crowdfunding,
       en.id_number,
       en.pref_mail_name,
       en.spouse_id_number                        spouse_id,
       en.spouse_mail_name,
       cuf_calc_names.get_name('JFM',a.id_number, CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' then 'B' else ' ' end) formal_mail_name,
       cuf_calc_names.get_name('JFS',a.id_number, CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' then 'B' else ' ' end) formal_sal,
       cuf_calc_names.get_name('JIM',a.id_number, CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' then 'B' else ' ' end) informal_mail_name,
       cuf_calc_names.get_name('JIS',a.id_number, CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' then 'B' else ' ' end) informal_sal,
       CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' then 'Y' else ' ' end               business_pref_ind,
       CASE WHEN nvl(en.bus_pref_addr_ind,' ') = 'Y' THEN en.business_title ELSE ' ' END business_title,
       CASE WHEN NVL(en.bus_pref_addr_ind,' ') = 'Y' THEN en.business_name ELSE ' ' END  business_name,
       en.line1                street1,
       en.line2                street2,
       en.line3                street3,
       en.city,
       en.state_code,
       en.zipcode,
       f1.affil_level          primary_affil,
       f2.affil_level          sp_primary_affil,
       f3.affil_level          current_parent_1,
       f31.affil_level         current_parent_2,/*
       f4.affil_level          past_parent_1,
       f41.affil_level         past_parent_2,*/
       --b.date_of_record        gift_date,
       a.alloc                 largest_gift_alloc,
       a.alloc_desc            largest_gift_alloc_desc,
       a.soft_credit           largest_gift_credit,
       rg1.date_of_record      recent_gift_date1,
       rg1.alloc               recent_gift_alloc1,
       rg1.alloc_desc          recent_gift_alloc_desc1,
       rg1.soft_credit         recent_gift_credit_1,
       rg2.date_of_record      recent_gift_date2,
       rg2.alloc               recent_gift_alloc2,
       rg2.alloc_desc          recent_gift_alloc_desc2,
       rg2.soft_credit         recent_gift_credit_2,
       rg3.date_of_record      recent_gift_date3,
       rg3.alloc               recent_gift_alloc3,
       rg3.alloc_desc          recent_gift_alloc_desc3,
       rg3.soft_credit         recent_gift_credit_3,
       al1.alloc               affil_alloc_1,
       al1.fund_name           affil_alloc_desc_1,
       
       al2.alloc               affil_alloc_2,
       al2.fund_name           affil_alloc_desc_2,
       al3.alloc               affil_alloc_3,
       al3.fund_name           affil_alloc_desc_3,
       al4.alloc               affil_alloc_4,
       al4.fund_name           affil_alloc_desc_4,
       al5.alloc               affil_alloc_5,
       al5.fund_name           affil_alloc_desc_5,
       al6.alloc               affil_alloc_6,
       al6.fund_name           affil_alloc_desc_6,
       al7.alloc               affil_alloc_7,
       al7.fund_name           affil_alloc_desc_7,
       al8.alloc               affil_alloc_8,
       al8.fund_name           affil_alloc_desc_8
FROM   (select * from tmp_largest_gift where seq = 1) a
         JOIN cuf_reporting_entity en  ON  a.id_number = en.id_number
         --left join tmp_gift_date   b   ON  en.id_number = b.donor_id
         left join tmp_gift rg1        on  a.id_number = rg1.id_number and rg1.seq = 1
         left join tmp_gift rg2        on  a.id_number = rg2.id_number and rg2.seq = 2
         left join tmp_gift rg3        on  a.id_number = rg3.id_number and rg3.seq = 3
         LEFT JOIN tmp_affil f1        ON  a.id_number = f1.id_number  AND f1.seq = 1
         LEFT JOIN tmp_affil f2        ON  a.id_number = f2.id_number  AND f2.seq = 2
         LEFT JOIN tmp_affil f3        ON  a.id_number = f3.id_number  AND f3.seq = 3 and f3.new_seq = 1
         LEFT JOIN tmp_affil f31       ON  a.id_number = f31.id_number AND f31.seq = 3 and f31.new_seq = 2/*
         LEFT JOIN tmp_affil f4        ON  a.id_number = f4.id_number  AND f4.seq = 4  and f4.new_seq  = 1
         LEFT JOIN tmp_affil f41       ON  a.id_number = f41.id_number AND f4.seq = 4  and f41.new_seq  = 2*/
         left join tmp_affil_alloc al1 ON  a.id_number = al1.id_number and al1.seq = 1
         left join tmp_affil_alloc al2 ON  a.id_number = al2.id_number and al2.seq = 2
         left join tmp_affil_alloc al3 ON  a.id_number = al3.id_number and al3.seq = 3
         left join tmp_affil_alloc al4 ON  a.id_number = al4.id_number and al4.seq = 4
         left join tmp_affil_alloc al5 ON  a.id_number = al5.id_number and al5.seq = 5
         left join tmp_affil_alloc al6 ON  a.id_number = al6.id_number and al6.seq = 6
         left join tmp_affil_alloc al7 ON  a.id_number = al7.id_number and al7.seq = 7
         left join tmp_affil_alloc al8 ON  a.id_number = al8.id_number and al8.seq = 8
WHERE  en.record_status_code = 'A';
-- select * from req_123307_affil 
-- select * from allocation where allocation_code = '0321301';

/*delete -- select distinct record_type -- select * -- select count(id_number), count(distinct id_number)
from   req_123307_set a
where  (a.gift_campus <> '2' and record_type not in ('AL','AN','ND','PA','FR'))
or     (a.gift_campus = '2'  and record_type not in ('AL','AN','ND','PA','FC', 'SF'));
commit;*/

delete -- select *
from   req_123307_set a
where  a.gift_campus = '2' and record_type not in ('AL','AN','ND','PA','FC', 'SF');

delete -- select *
from   req_123307_set a
where  a.gift_campus = '0'
and    a.record_type not in ('AL','AN','ND','PA','FC', 'SF')
and    ((a.recent_gift_alloc1 like '02%' and nvl(a.recent_gift_alloc2,' ') = ' ' and nvl(a.recent_gift_alloc3,' ') = ' ')
        OR (a.recent_gift_alloc1 like '02%' and nvl(a.recent_gift_alloc2,' ') like '02%' and nvl(a.recent_gift_alloc3,' ') = ' ')
        OR (a.recent_gift_alloc1 like '02%' and nvl(a.recent_gift_alloc2,' ') like '02%' and nvl(a.recent_gift_alloc3,' ') like '02%'));
commit;        

/*
select distinct friend_crowdfunding -- select * -- select gift_campus, count(*)
from   req_123307_set a 
where  friend_crowdfunding = 'Y' --and gift_campus = '8'
group by gift_campus
order by gift_campus
;
select * from entity where id_number = '0000152058' 
select *  -- select count(id_number), count(distinct id_number)
from   req_123307_set a 
where  nvl(a.spouse_id,' ') <> ' '
and    exists (select *
               from   req_123307_set b
               where  b.id_number = a.spouse_id 
               and    b.street1   = a.street1) ;

select * from req_123307_set a  where id_number in ('0000494124', '0000491288')               
select *
from   req_123307_set a 
where  id_number in (select id_number from req_123307_set group by id_number having count(id_number) > 1)
order by id_number;
select * from req_123307_set a where id_number in ('0000395839','0000572085');
select * from req_123307_set a where id_number in ('0000388690','0000389349');
select * from req_123307_set a where id_number in ('0000419436','0000035309');    */ 

*/
select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '0'
order by recent_gift_date1 desc, id_number;


select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '1'
order by recent_gift_date1 desc, id_number;

select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '2'
order by recent_gift_date1 desc, id_number;

select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '3'
order by recent_gift_date1 desc, id_number;

select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '4'
order by recent_gift_date1 desc, id_number;

select * -- select count(id_number), count(distinct id_number) -- select max(recent_gift_date1), min(recent_gift_date1)
from   req_123307_set 
where  gift_campus = '8'
order by recent_gift_date1 desc, id_number;

select gift_campus, campus_desc, count(id_number) "# Households", count(distinct id_number), min(recent_gift_date1), max(recent_gift_date1)
from   req_123307_set a
group by gift_campus, campus_desc
UNION
select '9', 'All', count(id_number) "# Households", count(distinct id_number), min(recent_gift_date1), max(recent_gift_date1)
from   req_123307_set a
order by 1; 

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
select * 
from   req_123307_set a
where  a.affil_alloc_1 is not null
and    a.affil_alloc_2 is not null
and    a.affil_alloc_3 is not null
and    a.affil_alloc_4 is not null
and    a.affil_alloc_5 is not null
and    a.affil_alloc_6 is not null
and    a.affil_alloc_7 is not null
and    a.affil_alloc_8 is not null

select * from affiliation where id_number = '0000455970';
select * from entity where id_number = '0000455970';

select *
from cuf_goals_dev_officer_cy;

select * from ids_base ;

select run_type_code, audience, subgroup, count(id) cnt
from cuf_ag_calling_ids
where  run_year = '2020'
group by run_type_code, audience, subgroup
order by run_type_code, audience, subgroup;

select p.id_number, e.primary_hh_entity_ind primay_ind
-- select count(p.id_number), count(distinct p.id_number)
from   cuf_reporting_parents p,
       cuf_reporting_entity e
where  parent_status = 'C'
and    p.id_number = e.id_number
and    e.record_status_code IN ('A','L')
and    e.home_country_code IN (' ','CA')
and    nvl(e.phone_number,' ') <> ' '
and    e.phone_number not like 'Do Not%'
AND    e.a1_ind = 'N' 
AND    e.noc_ind = 'N'
AND    e.nos_ind = 'N'
AND    e.nph_ind = 'N'
AND    e.nps_ind = 'N'  
and    NOT EXISTS(SELECT NULL 
                    FROM cuf_reporting_gift_pledge gpcurr
                   WHERE gpcurr.donor_id = e.id_number
                     AND gpcurr.year_of_giving >= '2020' -- to_char((i_run_year)) 
                     AND gpcurr.total_amt > 0) 
and    campus_code = '1' 
and    ( (p.student1_level_code in ('1','W') )
        or (nvl(p.student2_level_code,' ') <> ' ' and p.student2_level_code in ('1','W'))
        or (nvl(p.student3_level_code,' ') <> ' ' and p.student3_level_code in ('1','W')) )                            
 AND    e.id_number NOT IN (SELECT h.id_number
                          FROM handling h 
                          WHERE h.hnd_type_code = 'NAG' 
                          AND   h.hnd_status_code = 'A')
     -- Exclude if parent was already included earlier as a parent                             
 AND    e.id_number NOT IN (SELECT ag.id
                            FROM cuf_ag_calling_ids ag
                            WHERE ag.run_year = '2020'
                            AND   ag.audience = 'P'
                            AND   (trim(ag.subgroup) IS NULL
                                   OR instr(trim(ag.subgroup), '1') > 0))

select *
from   degrees d
where  local_ind = 'Y'
and    campus_code = '1'
       AND e.a1_ind = 'N' 
       AND e.noc_ind = 'N'
       AND e.nos_ind = 'N'
       AND e.nph_ind = 'N'
       AND e.nps_ind = 'N'   

select * from tms_degree_level;

select * from entity where id_number = '0001889221';
select * from cuf_ag_calling_ids where id = '0001885480';
select * from cuf_reporting_entity where id_number = '0001885480';
select * from affiliation where id_number = '0001885480';

select *
from   tms_record_type
order by cfae_code;


