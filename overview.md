#Overview

We present Eden's and Jacob's NanoTwitter, a project for COSI 105b at Brandeis University (Spring 2015). 

We set out to create a simplified version of [Twitter](twitter.com) that can withstand the test of scale. The purpose of the exercise was to demonstrate a variety of scaling techniques that were covered in the class - and put them into practice under controlled testing conditions in a live application.

We used the [Sinatra](www.sinatrarb.com) Ruby web framework to handle the server component, with Postgres for persistence and Redis for caching.

AJAX technologies like Javascript and jQuery were used in the front end to ensure fast delivery




The purpose of the project was to make a simplified version of Twitter to practice concepts of scalability. This simplified Twitter version has the ability to follow/unfollow people, view the tweets of the people that you follow, and to see both the users that you follow and the users that follow you. Hashtags and mentions are not a part of the simple Twitter project.

To practice scalability, this project had us look at several things. Firstly, we started with the basics of adding appropriate indices on the database tables. We also looked into the types of servers there are, such as Unicorn and Puma. We also added in AJAX calls to give the appearance of a faster loading website - the framework of the page would appear, then the contents are added; that way the end user sees progress on page load. We then added in Redis for caching to improve page load times.
