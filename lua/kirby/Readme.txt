groups.conf structure :

#Groupname
name:value
name:value
...

valid names & values : 
tag : tag
level : number > 0
color : valid RGB color (rrrgggbbb)
permissions : permission1,permission2,...
inherit-from : Groupname ---------OPTIONAL  inherits all permissions from the given group


users.conf structure ( 1 line / user ) :

name,usgn,Groupname

name : whatever
usgn : valid usgn
Groupname : valid groupname defined in groups.conf 