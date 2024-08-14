// Import accounts
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1CleF3Cqv6A3OfYMSDGOKkehNmpoRH36L' AS row
CREATE (:Account {
    id: toInteger(row.id),
    district_id: toInteger(row.district_id),
    frequency: row.frequency,
    date: date(row.date)
});

// Import cards
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1nVYmnLE0PuZ1KpztuHZP9VkBoDIdZ7u9' AS row
CREATE (:Card {
    id: toInteger(row.id),
    disp_id: toInteger(row.disp_id),
    type: row.type,
    issued: date(row.issued)
});

// Import clients
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1WQgzGEdCKGW_X7QXVHm_YGnoRbin8XF6' AS row
CREATE (:Client {
    id: toInteger(row.id),
    birth_number: row.birth_number,
    district_id: toInteger(row.district_id),
    tkey_id: toInteger(row.tkey_id)
});

// Import disps
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1LzdoxOCK3M3DXJT1x-jd60ZI7IOJeZXA' AS row
CREATE (:Disp {
    id: toInteger(row.id),
    client_id: toInteger(row.client_id),
    account_id: toInteger(row.account_id),
    type: row.type
});

// Import districts
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1pf9JU1lShgVitlkYse0Uhi0jwVtWx48F' AS row
CREATE (:District {
    id: toInteger(row.id),
    A2: row.A2,
    A3: row.A3,
    A4: row.A4,
    A5: row.A5,
    A6: row.A6,
    A7: row.A7,
    A8: row.A8,
    A9: row.A9,
    A10: row.A10,
    A11: row.A11,
    A12: row.A12,
    A13: row.A13,
    A14: row.A14,
    A15: row.A15,
    A16: row.A16
});

// Import loans
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1LbR4aTxrzAEvTQZDCbIFENwFp6_Jjvyt' AS row
CREATE (:Loan {
    id: toInteger(row.id),
    account_id: toInteger(row.account_id),
    date: date(row.date),
    amount: toFloat(row.amount),
    duration: toInteger(row.duration),
    payments: toInteger(row.payments),
    status: row.status
});

// Import orders
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1AhZAXiUpUVt81kczj2u79EtalB2uHoqb' AS row
CREATE (:Order {
    id: toInteger(row.id),
    account_id: toInteger(row.account_id),
    bank_to: row.bank_to,
    account_to: row.account_to,
    amount: toFloat(row.amount),
    k_symbol: row.k_symbol
});

// Import tkeys
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1W7sWgtFpxg2PVH0xyokLj7yJPkbRF2r0' AS row
CREATE (:TKey {
    id: toInteger(row.id),
    goodClient: row.goodClient
});

// Import trans
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1Pc9BI-Cnni-J30QpAQYbM3GrrjmYCRjd' AS row
CREATE (:Transaction {
    id: toInteger(row.id),
    account_id: toInteger(row.account_id),
    date: date(row.date),
    type: row.type,
    operation: row.operation,
    amount: toFloat(row.amount),
    balance: toFloat(row.balance),
    k_symbol: row.k_symbol,
    bank: row.bank,
    account: row.account
});

// Cards - Disps (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1nVYmnLE0PuZ1KpztuHZP9VkBoDIdZ7u9' AS row
MATCH (c:Card {id: toInteger(row.id)}), (d:Disp {id: toInteger(row.disp_id)})
CREATE (c)-[:HAS_DISP]->(d);

// Disps - Clients (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1LzdoxOCK3M3DXJT1x-jd60ZI7IOJeZXA' AS row
MATCH (d:Disp {id: toInteger(row.id)}), (cl:Client {id: toInteger(row.client_id)})
CREATE (d)-[:BELONGS_TO_CLIENT]->(cl);

// Disps - Accounts (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1LzdoxOCK3M3DXJT1x-jd60ZI7IOJeZXA' AS row
MATCH (d:Disp {id: toInteger(row.id)}), (a:Account {id: toInteger(row.account_id)})
CREATE (d)-[:HAS_ACCOUNT]->(a);

// Districts - Clients (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1WQgzGEdCKGW_X7QXVHm_YGnoRbin8XF6' AS row
MATCH (cl:Client {id: toInteger(row.id)}), (d:District {id: toInteger(row.district_id)})
CREATE (cl)-[:BELONGS_TO_DISTRICT]->(d);

// Districts - Accounts (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1CleF3Cqv6A3OfYMSDGOKkehNmpoRH36L' AS row
MATCH (a:Account {id: toInteger(row.id)}), (d:District {id: toInteger(row.district_id)})
CREATE (a)-[:BELONGS_TO_DISTRICT]->(d);

// Loans - Accounts (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1LbR4aTxrzAEvTQZDCbIFENwFp6_Jjvyt' AS row
MATCH (l:Loan {id: toInteger(row.id)}), (a:Account {id: toInteger(row.account_id)})
CREATE (l)-[:ASSOCIATED_WITH_ACCOUNT]->(a);

// Accounts - Orders (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1AhZAXiUpUVt81kczj2u79EtalB2uHoqb' AS row
MATCH (o:Order {id: toInteger(row.id)}), (a:Account {id: toInteger(row.account_id)})
CREATE (o)-[:PLACED_BY_ACCOUNT]->(a);

// Accounts - Transactions (many-to-many)
LOAD CSV WITH HEADERS FROM 'https://drive.google.com/uc?export=download&id=1Pc9BI-Cnni-J30QpAQYbM3GrrjmYCRjd' AS row
MATCH (t:Transaction {id: toInteger(row.id)}), (a:Account {id: toInteger(row.account_id)})
CREATE (t)-[:ASSOCIATED_WITH_ACCOUNT]->(a);
