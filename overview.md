#Overview

We present Eden's and Jacob's NanoTwitter, a project for COSI 105b at Brandeis University (Spring 2015). 

We set out to create a simplified version of [Twitter](twitter.com) that can withstand the test of scale. The purpose of the exercise was to demonstrate a variety of scaling techniques that were covered in the class - and put them into practice under controlled testing conditions in a live application.

We used the [Sinatra](www.sinatrarb.com) Ruby web framework to handle the server component, with Postgres for persistence and Redis for caching.

AJAX technologies like Javascript and jQuery were used in the front end to ensure good user experience, and good user interface design guidelines were followed to make an intuitive product - such that anyone who uses Twitter can enjoy the basic feature set of NanoTwitter.

The name of the class is "Software Engineering and Architecture to Scale", and indeed - the major focus of this product was the ability to scale up and be capable of handling a large amount of simultaneous users. We used the load testing utility [loader.io](www.loader.io) to provide reliable and consistent load testing data, effectively enabling us to run multiple tests following any change to the system, to see a change in responsiveness.

By validating changes to the system increased speed, we were able to effectively have an incremental approach to scaling.



The purpose of the project was to make a simplified version of Twitter to practice concepts of scalability. This simplified Twitter version has the ability to follow/unfollow people, view the tweets of the people that you follow, and to see both the users that you follow and the users that follow you. Hashtags and mentions are not a part of the simple Twitter project.

To practice scalability, this project had us look at several things. Firstly, we started with the basics of adding appropriate indices on the database tables. We also looked into the types of servers there are, such as Unicorn and Puma. We also added in AJAX calls to give the appearance of a faster loading website - the framework of the page would appear, then the contents are added; that way the end user sees progress on page load. We then added in Redis for caching to improve page load times.
