   insert into ch19.consumption_zone.item_dim (
        item_id,
        item_desc,
        start_date,
        end_date,
        price,
        item_class,
        item_category) 
    select 
        item_id,
        item_desc,
        start_date,
        end_date,
        price,
        item_class,
        item_category
    from ch19.curated_zone.curated_item;

    insert into ch19.consumption_zone.customer_dim (
        customer_id ,
        salutation ,
        first_name ,
        last_name ,
        birth_day ,
        birth_month ,
        birth_year ,
        birth_country ,
        email_address ) 
    select 
        customer_id ,
        salutation ,
        first_name ,
        last_name ,
        birth_day ,
        birth_month ,
        birth_year ,
        birth_country ,
        email_address 
  from ch19.curated_zone.curated_customer;

  insert into ch19.consumption_zone.order_fact (
      order_date,
      customer_dim_key ,
      item_dim_key ,
      order_count,
      order_quantity ,
      sale_price ,
      disount_amt ,
      coupon_amt ,
      net_paid ,
      net_paid_tax ,
      net_profit 
    ) 
    select 
      co.order_date,
      cd.customer_dim_key ,
      id.item_dim_key,
      count(1) as order_count,
      sum(co.order_quantity) ,
      sum(co.sale_price) ,
      sum(co.disount_amt) ,
      sum(co.coupon_amt) ,
      sum(co.net_paid) ,
      sum(co.net_paid_tax) ,
      sum(co.net_profit)  
    from ch19.curated_zone.curated_order co 
    join ch19.consumption_zone.customer_dim cd on cd.customer_id = co.customer_id
    join ch19.consumption_zone.item_dim id on id.item_id = co.item_id and id.item_desc = co.item_desc and id.end_date is null
    group by 
        co.order_date,
        cd.customer_dim_key ,
        id.item_dim_key
        order by co.order_date;