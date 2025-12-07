-- product_dim
	CREATE TABLE IF NOT EXISTS product_dim (
	    product_pk VARCHAR(250) PRIMARY KEY,
	    product_name VARCHAR(250) NOT NULL,
	    product_price NUMERIC,
	    toys BOOLEAN DEFAULT FALSE,
	    entertainment BOOLEAN DEFAULT FALSE,
	    breakfast BOOLEAN DEFAULT FALSE,
	    lunch BOOLEAN DEFAULT FALSE,
	    dinner BOOLEAN DEFAULT FALSE,
	    accessories BOOLEAN DEFAULT FALSE,
	    kitchenware BOOLEAN DEFAULT FALSE,
	    grocery BOOLEAN DEFAULT FALSE,
	    apparel BOOLEAN DEFAULT FALSE,
	    furniture BOOLEAN DEFAULT FALSE,
	    health BOOLEAN DEFAULT FALSE,
	    hygiene BOOLEAN DEFAULT FALSE,
	    stationary BOOLEAN DEFAULT FALSE,
	    tools BOOLEAN DEFAULT FALSE,
	    jewelry BOOLEAN DEFAULT FALSE,
	    technology BOOLEAN DEFAULT FALSE,
	    electronics BOOLEAN DEFAULT FALSE,
	    sports BOOLEAN DEFAULT FALSE,
	    cosmetic BOOLEAN DEFAULT FALSE,
	    music BOOLEAN DEFAULT FALSE,
	    cleaning BOOLEAN DEFAULT FALSE,
	    appliances BOOLEAN DEFAULT FALSE,
	    others BOOLEAN DEFAULT FALSE
	);
	INSERT INTO product_dim (
	    product_pk,
	    product_name,
	    product_price,
	    toys,
	    entertainment,
	    breakfast,
	    lunch,
	    dinner,
	    accessories,
	    kitchenware,
	    grocery,
	    apparel,
	    furniture,
	    health,
	    hygiene,
	    stationary,
	    tools,
	    jewelry,
	    technology,
	    electronics,
	    sports,
	    cosmetic,
	    music,
	    cleaning,
	    appliances,
	    others
	)
	SELECT DISTINCT
	    cp.product_pk,
	    cp.product_name,
	    cp.product_price,
	    cp.toys,
	    cp.entertainment,
	    cp.breakfast,
	    cp.lunch,
	    cp.dinner,
	    cp.accessories,
	    cp.kitchenware,
	    cp.grocery,
	    cp.apparel,
	    cp.furniture,
	    cp.health,
	    cp.hygiene,
	    cp.stationary,
	    cp.tools,
	    cp.jewelry,
	    cp.technology,
	    cp.electronics,
	    cp.sports,
	    cp.cosmetic,
	    cp.music,
	    cp.cleaning,
	    cp.appliances,
	    cp.others
	FROM
	    clean_product cp
	WHERE
	    cp.product_pk IS NOT NULL
	    AND NOT EXISTS (
	        SELECT 1
	        FROM product_dim pd
	        WHERE pd.product_pk = cp.product_pk
	    );
	INSERT INTO product_dim (product_pk, product_name)
    VALUES (0, 'Unknown');

-- user_dim
    CREATE TABLE IF NOT EXISTS user_dim (
        user_pk TEXT PRIMARY KEY,
        user_name VARCHAR(250),
        user_creation_datetime TIMESTAMP,
        user_street VARCHAR(250),
        user_state VARCHAR(250),
        user_city VARCHAR(250),
        user_country VARCHAR(250),
        user_birthdate TIMESTAMP,
        user_gender VARCHAR(250),
        user_device_address VARCHAR(250),
        user_type VARCHAR(250),
        user_job_title VARCHAR(250),
        user_job_level VARCHAR(250),
        user_credit_card_number VARCHAR(250),
        user_issuing_bank VARCHAR(250)
    );
    INSERT INTO user_dim (
        user_pk,
        user_name,
        user_creation_datetime,
        user_street,
        user_state,
        user_city,
        user_country,
        user_birthdate,
        user_gender,
        user_device_address,
        user_type,
        user_job_title,
        user_job_level,
        user_credit_card_number,
        user_issuing_bank
    )
    SELECT DISTINCT
        cu.user_pk,
        cu.user_name,
        cu.user_creation_datetime,
        cu.user_street,
        cu.user_state,
        cu.user_city,
        cu.user_country,
        cu.user_birthdate,
        cu.user_gender,
        cu.user_device_address,
        cu.user_type,
        cu.user_job_title,
        cu.user_job_level,
        cu.user_credit_card_number,
        cu.user_issuing_bank
    FROM
        clean_user cu
    WHERE
        cu.user_pk IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM user_dim ud
            WHERE ud.user_pk = cu.user_pk
        );
	INSERT INTO user_dim (user_pk, user_name)
    VALUES (0, 'Unknown');

-- merchant_dim
    CREATE TABLE IF NOT EXISTS merchant_dim (
            merchant_pk TEXT PRIMARY KEY,
            merchant_name VARCHAR(250) NOT NULL,
            merchant_street VARCHAR(250),
            merchant_state VARCHAR(250),
            merchant_city VARCHAR(250),
            merchant_country VARCHAR(250),
            merchant_contact_number VARCHAR(250),
            merchant_creation_datetime TIMESTAMP
        );
        INSERT INTO merchant_dim (
            merchant_pk,
            merchant_name,
            merchant_street,
            merchant_state,
            merchant_city,
            merchant_country,
            merchant_contact_number,
            merchant_creation_datetime
        )
        SELECT DISTINCT
            cm.merchant_pk,
            cm.merchant_name,
            cm.merchant_street,
            cm.merchant_state,
            cm.merchant_city,
            cm.merchant_country,
            cm.merchant_contact_number,
            cm.merchant_creation_datetime
        FROM
            clean_merchant cm
        WHERE
            cm.merchant_pk IS NOT NULL
            AND NOT EXISTS (
                SELECT 1
                FROM merchant_dim md
                WHERE md.merchant_pk = cm.merchant_pk
            );
	INSERT INTO merchant_dim (merchant_pk, merchant_name)
    VALUES (0, 'Unknown');

-- staff_dim
    CREATE TABLE IF NOT EXISTS staff_dim (
        staff_pk TEXT PRIMARY KEY,
        staff_name VARCHAR(250) NOT NULL,
        staff_job_level VARCHAR(250),
        staff_street VARCHAR(250),
        staff_state VARCHAR(250),
        staff_city VARCHAR(250),
        staff_country VARCHAR(250),
        staff_contact_number VARCHAR(250),
        staff_creation_datetime TIMESTAMP
    );
    INSERT INTO staff_dim (
    staff_pk,
    staff_name,
    staff_job_level,
    staff_street,
    staff_state,
    staff_city,
    staff_country,
    staff_contact_number,
    staff_creation_datetime
    )
    SELECT DISTINCT
        cs.staff_pk,
        cs.staff_name,
        cs.staff_job_level,
        cs.staff_street,
        cs.staff_state,
        cs.staff_city,
        cs.staff_country,
        cs.staff_contact_number,
        cs.staff_creation_datetime
    FROM
        clean_staff cs
    WHERE
        cs.staff_pk IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM staff_dim sd
            WHERE sd.staff_pk = cs.staff_pk
        );
	INSERT INTO staff_dim (staff_pk, staff_name)
    VALUES (0, 'Unknown');

-- campaign_dim
    CREATE TABLE IF NOT EXISTS campaign_dim (
        campaign_pk VARCHAR(250) PRIMARY KEY,
        campaign_name VARCHAR(250) NOT NULL,
        campaign_description TEXT,
        campaign_description_person TEXT,
        campaign_discount DOUBLE PRECISION
    );
    INSERT INTO campaign_dim (
        campaign_pk,
        campaign_name,
        campaign_description,
        campaign_description_person,
        campaign_discount
    )
    SELECT DISTINCT
        cc.campaign_id,
        cc.campaign_name,
        cc.campaign_description,
        cc.campaign_description_person,
        cc.campaign_discount
    FROM
        clean_campaign cc
    WHERE
        cc.campaign_id IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM campaign_dim cd
            WHERE cd.campaign_pk = cc.campaign_id
        );
	INSERT INTO campaign_dim (campaign_pk, product_name)
    VALUES (0, 'Unknown');