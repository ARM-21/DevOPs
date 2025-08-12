To continously integrate and deployment
we use pipeline to flow the data through pipe.

Github actions is not a pipeline
pipeline is attached to the github actions


push-> event generate
on push event -> a structured file is triggered to run a flow
e.g. - ci.yml -> to run and test the developed program.
sonar cloud -> scanning we can access the key 

stucture of yaml file:-
	indentation
	name: name of the program
	on: 
			push:
				branches:[main]
			pull_request:
				branches:[main]
	jobs:
		
pre-commit - hooks