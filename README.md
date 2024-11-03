## Inspiration
Many people have had their cats simply disappear from their homes due to how independent and cunning they can be. This project was made to help others who may be or have been, in similar situations where their furry friends have gone missing. It is also meant to be an entertaining way to find local cats in your area, stray or otherwise. 

## What it does
Users would be able to login and add their cats, making it easier for people to identify cats that belong to them. They would also be able to upload photos of local cat sightings, which would then use image classification to identify the breed, coat pattern, and age of the cat, and then use a vector similarity search to identify a registered cat that looked as close to the cat in the photo as possible.

They'd also be able to see cats in their community and where they've been previously spotted by others.

## How we built it
Our initial goal was to simplify the code needed to communicate between the interface and our backend, so we deployed a self-hosted instance of Supabase on a virtual private server using docker and terraform. We deployed additional containers for weaviate, an open-source vector database that stores both objects and vectors, for our image similarity search and a custom Python backend made using FastAPI that utilized the JWT from supabase for authorization and served as the in-between for the front end and our AI-powered tools. 

Our front end was written entirely using SwiftUI for iOS devices, with the plan originally being to connect the two once both were ready for integration, but that proved to be much more difficult than anticipated. 

## Challenges we ran into
We had to construct our Terraform file to replicate an existing highly complicated stack which took far longer than expected. Still, we wanted to be able to use our own instance of the application since it was open-source and played a large role in our application since it handled image storage, authentication, and the storage of other data.

When finally integrating parts of our application, we ran into a slew of problems. There was far more difficulty involved in integrating superbase in Swift than initially anticipated, exacerbated by Swift's very strict typing. This made us unable to complete our project to our satisfaction in the time provided. 

## Accomplishments that we're proud of
This was the first hackathon of, and the first fully interactive interface created by, one of our members. So we're very proud of what we accomplished in such a short time. We knew very well that it would be a daunting task that may not be completed, but it was a challenge we simply couldn't turn down. 

We're also very proud of the lengths we went to for the actual deployment of our project. We gained a lot of experience working on an actual server for deployment, having to understand the importance of all of the application's components on a deeper level, especially networking and environment isolation, instead of abstracting or concealing the inner workings like using the cloud does. We even secured our API and our admin portal behind an HTTPS reverse proxy!

## What we learned
We learned... a lot. A lot of time was spent looking at various options for structuring a user's mobile experience, especially in the hierarchy between views and what is most convenient for a user vs. what is most convenient for a developer. We also learned that an insane amount goes into securing communications between devices across platforms for what may seem like a relatively simple task. 

## What's next for Cat-egorize
Completion. Though we weren't able to fully realize our dream for the application, we are determined to see it complete, no matter what it takes to do so. This will largely be an effort to flesh out full-scale communication between our backend and frontend.

## AI Usage
We primarily used large language models to understand our shortcomings when faced with difficult problems. These models were usually not used until some notable amount of time had been spent attempting to solve the problem, and their usage was oriented largely towards the understanding of both the cause and the solution, rather than a temporary fix to iterate as quickly as possible. We also utilized GPT-4o for it's vision component, as we found it was a far more feasible solution for cat breed identification within our 24 hour time limit, rather than attempting to train an image detection and classification model with limited data in such a short time. 
