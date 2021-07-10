select a.시군
     , a.지정구분
     , nvl(b.관측도수,0) 관측도수 /*관측되지않은 (시군+지정구분)은 0으로 처리*/
     , a.기대도수_시군 * a.기대도수_지정구분 / a.기대도수_전체 기대도수
from (
      select x.시군, y.지정구분
           , x.기대도수_시군
           , y.기대도수_지정구분
           , x.기대도수_전체
      from ( select 시군
                  , count(*) 기대도수_시군 /* 시군 속성의 cardinality */
                  , sum(count(*)) over () 기대도수_전체 /* 전체 행 개수 */
             from d_base3_2
             group by 시군 ) x,
           ( select 지정구분
                  , count(*) 기대도수_지정구분 /* 지정구분 속성의 cardinality */
             from d_base3_2
             group by 지정구분 ) y ) a,
     ( select 시군
            , 지정구분
            , count(*) 관측도수 /* 시군, 지정구분 별 실제 행 개수 */
       from d_base3_2
       group by 시군, 지정구분 ) b
where a.시군 = b.시군(+) /* 특정 (시군+지정구분) 값은 존재하지 않을 수 있어서 외부조인으로 처리 */
  and a.지정구분 = b.지정구분(+) ;