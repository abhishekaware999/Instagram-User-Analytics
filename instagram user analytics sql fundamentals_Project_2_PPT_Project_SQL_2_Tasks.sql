use ig_clone;
#A) Marketing Analysis:
/*
1.Loyal User Reward: 
Identify the five oldest users on Instagram from the provided database.
*/
select
 id, username, rank() over(order by created_at) as ranking
from users limit 5;
/*
2.Inactive User Engagement:
Your Task: Identify users who have never posted a single photo on Instagram.
*/
select
	id, username
from users
where id not in (select user_id from photos);

/*
3.Contest Winner Declaration:
Your Task: Determine the winner of the contest and provide their details to the team.
*/
SELECT * 
FROM users 
WHERE id = (
  SELECT p.user_id 
  FROM likes l 
  JOIN photos p ON l.photo_id = p.id 
  GROUP BY l.photo_id 
  ORDER BY COUNT(l.user_id) DESC 
  LIMIT 1
);

/*
4.Hashtag Research:
Your Task: Identify and suggest the top five most commonly used hashtags on the platform.
*/
select * from tags;
select * from photo_tags;
-- select tag_name from tags where id in (
-- select tag_id,count(tag_id) as tag_count
-- from photo_tags
-- group by tag_id
-- order by tag_count desc 
-- limit 5);

with poppular_tags as(
select tag_id,count(tag_id) as tag_count
from photo_tags
group by tag_id
order by tag_count desc 
limit 5)

select tags.tag_name
from tags
inner join poppular_tags p on p.tag_id=tags.id;

/*
5.Ad Campaign Launch:
Your Task: Determine the day of the week when most users register on Instagram.
*/
select * from users;
select day(created_at) from users;
select extract(day from created_at) from users;

select dayname (created_at) as day_name, count(id) as user_count
from users
group by dayname (created_at)
order by user_count desc ;

#B) Investor Metrics:
/*
User Engagement:
Your Task: Calculate the average number of posts per user on Instagram.
		   Also, provide the total number of photos on Instagram divided by the total number of users.
*/
select * from photos;
select * from users;

select p.user_id,u.username, count(p.id) as number_of_posts
from photos p 
inner join users u on p.user_id=u.id
group by user_id;

select
	(select count(distinct(id)) as Total_Photos from photos)
	/
	(select count(distinct(id)) as Total_Users from users) as Photos_by_users;
    
/*2.Bots & Fake Accounts:
Your Task: Identify users (potential bots) who have liked every single photo on the site,
		   as this is not typically possible for a normal user.
*/
select * from likes;
select user_id,count(distinct(photo_id)) as user_photo_like_count
from likes
group by user_id
having count(distinct(photo_id))=(select count(id) from photos);








