# Homecoming

## Background

1. An API endpoint that can accept both payload formats. See payloads section below.
2. Your code should not require any additional headers or parameters to
distinguish between the 2 payloads.
3. Parse and save the payloads to a Reservation model that belongs to a Guest
model. Reservation code and guest email field should be unique.
4. API should be able accept changes to the reservation. e.g., change in status,
check-in/out dates, number of guests, etc...

## Getting Started

Please ensure you have installed Ruby in your machine. Then follow these steps:

1. Clone the repo

```
git clone git@github.com:absyah/homecoming.git
```

2. Run `bin/setup` to prepare the database, migration, and dependencies installation

3. Run `rails s` to start the server

4. Access the API endpoints throught http://localhost:3000

5. To run the test, simply run `rspec` from terminal.


## Endpoint

### Create or Update Reservation

#### [POST] /api/v1/reservations

Create or update reservation based on the reservation code and guest email address.

#### _Sample Request_

For the payload, please find *payload1.json* or *payload2.json* JSON file in the application root directory.

```
curl -X POST -H "Content-Type: application/json" -d @payload2.json http://localhost:3000/api/v1/reservations
```

#### Response Payload Data Attributes

#### _Reservation Object_

| Attributes  | Data Type | Note
| ------------- | ------------- | ------------- |
| `id`  | numeric  |               |
| `reservation_code`  | numeric  | Code of reservation |
| `start_date`  | date  | Start date of reservation |
| `end_date`  | date  | End date of reservation |
| `nights`  | numeric  | Duration of reservation |
| `guests`  | numeric  | Number of guests |
| `adutls`  | numeric  | Number of adult guests |
| `children`  | numeric  | Number of kid guests |
| `infants`  | numeric  | Number of infant guests |
| `localized_description`  | string  | Number of guests in text |
| `status`  | string  | Status of reservation |
| `currency`  | string  | Currency of reservation payment |
| `payout_price`  | string  | Payout price of reservation |
| `security_price`  | string  | Security price of reservation |
| `total_price`  | string  | Total price of reservation |
| `created_at`  | datetime  | Reservation created at (auto) |
| `updated_at`  | datetime  | Reservation updated at (auto) |
| `guest_id`  | numeric  | Foreign key of guest entity |
| `guest`  | Guest Object  | Guest that associated with the reservation |


#### _Guest Object_

| Attributes  | Data Type | Note
| ------------- | ------------- | ------------- |
| `id`  | numeric  |               |
| `first_name`  | string  | Guest first name |
| `last_name`  | string  | Guest last name |
| `phone_numbers`  | string  | Guest phone numbers |
| `email`  | string  | Guest email |
| `created_at`  | datetime  | Guest created at (auto) |
| `updated_at`  | datetime  | Guest updated at (auto) |



#### 200 Success Response

```
{
    "id": 1,
    "reservation_code": "XXX12345678",
    "start_date": "2021-03-12",
    "end_date": "2021-03-16",
    "nights": 4,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "localized_description": "4 guests",
    "status": "accepted",
    "currency": "AUD",
    "payout_price": "3800.0",
    "security_price": "500.0",
    "total_price": "4300.0",
    "created_at": "2023-05-26T06:44:53.770Z",
    "updated_at": "2023-05-26T06:44:53.770Z",
    "guest_id": 1,
    "guest": {
        "id": 1,
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone_numbers": "639123456789, 639123456789",
        "email": "wayne_woodbridge@bnb.com",
        "created_at": "2023-05-26T06:44:53.731Z",
        "updated_at": "2023-05-26T06:44:53.731Z"
    }
}
```

### Error Responses

Error response consists of json with `message` attribute.

```
{
    "message": <text>
}
```

#### 422 Unprocessable Entity

*Example:*

```
{
    "message": "[\"Reservation code has already been taken\"]"
}
```

#### 400 Bad Request

*Example*

```
{
    "message": "found unpermitted parameter: :unpermitted_custom_attribute"
}
```

## Accepted Request Payloads

### Request Payload 1

```
{
    "reservation_code": "YYY87654321",
    "start_date": "2021-04-14",
    "end_date": "2021-04-18",
    "nights": 4,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "guest": {
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
    },
    "currency": "AUD",
    "payout_price": "4200.00",
    "security_price": "500",
    "total_price": "4700.00"
}
```

### Request Payload 2

```
{
    "reservation": {
        "code": "XXX12345678",
        "start_date": "2021-03-12",
        "end_date": "2021-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
            "localized_description": "4 guests",
            "number_of_adults": 2,
            "number_of_children": 2,
            "number_of_infants": 0
        },
        "guest_email": "wayne_woodbridge@bnb.com",
        "guest_first_name": "Wayne",
        "guest_last_name": "Woodbridge",
        "guest_phone_numbers": [
            "639123456789",
            "639123456789"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4300.00"
    }
}
```

## Adding New Request Payload

This application has the capability to handle multiple forms of reservation payloads, currently supporting Payload1 and Payload2. If there is a need to incorporate another payload, you can follow these steps:

1. Navigate to the *lib/payload* directory.

2. Create a new payload parser file, such as `v3_parser.rb`.

3. In this new file, register the attributes specific to the new payload. This is done by defining a `PERMITTED_PARAMS` constant and including the attributes of the new payload that you want to allow.

4. Map the attributes of the new payload to the corresponding attributes in the `Reservation` and `Guest` models.

5. Modify the condition in the *lib/payload/base_parser.rb* file to utilize the `V3Parser` when encountering the new payload.
