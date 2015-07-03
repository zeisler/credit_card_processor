# CreditCardProcessor

Basic Credit Card Processing Terminal App

## Installation

Run `bin/setup` to install dependencies

## Usage

### STDIN

run `bin/process` takes stdin.

Commands 

  `add person_name credit_card_number credit_limit`
  
  `charge person_name amount`
  
  `credit person_name amount`
  
  `exit` To quit and see summary.

### File Path

run `bin/process example_input.txt`

## Design Decisions

A distinction in my design is that the entities `Person, Transaction, CreditCardAccount, etc` are used as if they are immutable. When a mutation is needed with `CreditCardAccount` a new instance is created with the old attributes and a new balance attribute. 