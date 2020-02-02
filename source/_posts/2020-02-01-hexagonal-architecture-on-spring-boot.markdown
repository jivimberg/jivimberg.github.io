---
layout: post
title: "Hexagonal Architecture on Spring Boot"
date: 2020-02-01 20:51:59 -0800
comments: true
categories: java hexagonal architecture spring spring-boot
---

In this article, I'll show how to implement a Spring Boot application using Hexagonal Architecture.

<!--more-->

We'll build a Bank Account simulation with _deposit_ and _withdraw_ operations exposed through REST endpoints.

## Hexagonal Architecture

Hexagonal architecture is an architectural style that **focuses on keeping the business logic decoupled from external concerns**.

The business core interacts with other components through ports and adapters. This way, we can change the underlying technologies without having to modify the application core.

{% img center /images/posts/2020-02-01/HexagonalArchitecture-generic.png 700 ‘Generic Hexagonal Architecture diagram’ %}

## Application Core

### Domain Model
Let's start with the domain model. Its main responsibility is to model the business rules. It also verifies that the objects are always in a valid state:

{% codeblock lang:java BankAccount.java %}
public class BankAccount {

		private Long id;
		private BigDecimal balance;

		// Constructor

		public boolean withdraw(BigDecimal amount) {
			if(balance.compareTo(amount) < 0) {
				return false;
			}

			balance = balance.subtract(amount);
			return true;
		}

		public void deposit(BigDecimal amount) {
			balance = balance.add(amount);
		}

}
{% endcodeblock %}

The domain model should have no dependency on any specific technology. That's the reason why you'll find no Spring annotations here.

### Ports

Now it's time to have our business logic interact with the outside world. To achieve this, we'll introduce some ports.

First, let's define 2 Incoming ports. **These are used by external components to call our application**. In this case, we'll have one per use case. One for _Deposit_:

{% codeblock lang:java DepositUseCase.java %}
public interface DepositUseCase {
		void deposit(Long id, BigDecimal amount);
}
{% endcodeblock %}

And one for _Withdraw_:

{% codeblock lang:java WithdrawUseCase.java %}
public interface WithdrawUseCase {
		boolean withdraw(Long id, BigDecimal amount);
}
{% endcodeblock %}

Similarly, we'll also have 2 Outgoing ports. **These are for our application to interact with the database**. Once again, we'll have one per use case. One for _Loading_ the Account:

{% codeblock lang:java LoadAccountPort.java %}
public interface LoadAccountPort {
		Optional<BankAccount> load(Long id);
}
{% endcodeblock %}

And one for _Saving_ it:

{% codeblock lang:java SaveAccountPort.java %}
public interface SaveAccountPort { 
		void save(BankAccount bankAccount); 
}
{% endcodeblock %}

### 3.3 Service
Next, we'll create a service to tie all the pieces together and drive the execution:

{% codeblock lang:java BankAccountService.java %}
public class BankAccountService implements DepositUseCase, WithdrawUseCase {

		private LoadAccountPort loadAccountPort;
		private SaveAccountPort saveAccountPort;

		// Constructor

		@Override
		public void deposit(Long id, BigDecimal amount) {
			BankAccount account = loadAccountPort.load(id)
					.orElseThrow(NoSuchElementException::new);
	
			account.deposit(amount);

			saveAccountPort.save(account);
		}

		@Override
		public boolean withdraw(Long id, BigDecimal amount) {
			BankAccount account = loadAccountPort.load(id)
					.orElseThrow(NoSuchElementException::new);

			boolean hasWithdrawn = account.withdraw(amount);
	
			if(hasWithdrawn) {
				saveAccountPort.save(account);
			}
			return hasWithdrawn;
		}
}
{% endcodeblock %}

Note how the service implements the incoming ports. On each method, it uses the _Load_ port to fetch the account from the database. Then, it performs the changes on the domain model. And finally, it saves those changes through the _Save_ port.

## Adapters

### Web

To complete our application, we need to provide implementations for the defined ports. We call these adapters.

For the incoming interactions, we'll create a REST controller:

{% codeblock lang:java BankAccountController.java %}
@RestController
@RequestMapping("/account")
public class BankAccountController {

		private final DepositUseCase depositUseCase;
		private final WithdrawUseCase withdrawUseCase;

		// Constructor

		@PostMapping(value = "/{id}/deposit/{amount}")
		void deposit(@PathVariable final Long id, @PathVariable final BigDecimal amount) {
			depositUseCase.deposit(id, amount);
		}

		@PostMapping(value = "/{id}/withdraw/{amount}")
		void withdraw(@PathVariable final Long id, @PathVariable final BigDecimal amount) {
			withdrawUseCase.withdraw(id, amount);
		}
	}
{% endcodeblock %}

The controller uses the defined ports to make calls to the application core.

### Persistence

For the persistence layer, we'll use Mongo DB through Spring Data:

{% codeblock lang:java SpringDataBankAccountRepository.java %}
public interface SpringDataBankAccountRepository extends MongoRepository<BankAccount, Long> { }
{% endcodeblock %}
  
Also, we'll create a _BankAccountRepository_ class that connects the outgoing ports with the _SpringDataBankAccountRepository_:

{% codeblock lang:java BankAccountRepository.java %}
@Component
public class BankAccountRepository implements LoadAccountPort, SaveAccountPort {

		private SpringDataBankAccountRepository repository;

		// Constructor

		@Override
		public Optional<BankAccount> load(Long id) {
			return repository.findById(id);
		}

		@Override
		public void save(BankAccount bankAccount) {
			repository.save(bankAccount);
		}
}

{% endcodeblock %}

### Infrastructure

Finally, we need to tell Spring to expose the _BankAccountService_ as a bean, so it can be injected in the controller:

{% codeblock lang:java BeanConfiguration.java %}
@Configuration
@ComponentScan(basePackageClasses = HexagonalApplication.class)
public class BeanConfiguration {

		@Bean
		BankAccountService bankAccountService(BankAccountRepository repository) {
			return new BankAccountService(repository, repository);
		}
}
{% endcodeblock %}

Defining the beans in the Adapters layer helps us maintain the infrastructure code decoupled from the business logic.

## Conclusion

In this article, we've seen how to implement an application using Hexagonal Architecture and Spring Boot. This is what the system ends up looking like:

{% img center /images/posts/2020-02-01/HexagonalArchitecture-impl.png 700 ‘Generic Hexagonal Architecture Spring Boot example’ %}

The code for this example is [available on Github][1].

---- 
This article is based on the _highly recommendable_ ["Get Your Hands Dirty on Clean Architecture][2] by [Tom Hombergs][3], and [this Baeldung article][4] by [Łukasz Ryś][5].  


 {% img right-fill /images/signatures/signature9.png 200 ‘My signature’ %} 

[1]:	https://github.com/jivimberg/hexagonal-architecture
[2]:	https://leanpub.com/get-your-hands-dirty-on-clean-architecture
[3]:	https://twitter.com/TomHombergs
[4]:	https://www.baeldung.com/hexagonal-architecture-ddd-spring
[5]:	https://www.baeldung.com/author/lukasz-rys/