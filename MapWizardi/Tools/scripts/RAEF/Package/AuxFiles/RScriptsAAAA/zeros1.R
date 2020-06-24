

Out1 <<- read.csv(filename1000)
Data0 <<- cbind(Out1[3], Out1[4]) 

###count(Data0, BestMMethod)  ## use - finds number of blanks, and each mine type


mylist <- split(Data0 , Data0$Dcat10)
Dcat10 <<- mylist[[10]]
Dcat9 <<- mylist[[9]]
Dcat8 <<- mylist[[8]]
Dcat7 <<- mylist[[7]]
Dcat6 <<- mylist[[6]]
Dcat5 <<- mylist[[5]]
Dcat4 <<- mylist[[4]]
Dcat3 <<- mylist[[3]]
Dcat2 <<- mylist[[2]]
Dcat1 <<- mylist[[1]]

## Gen Count 
GenCount<<- count(Data0,MT) 
Blank <<- 0
BCG <<- 0
NG <<- 0
OPG <<- 0
RPG <<- 0
VCRG <<- 0



if( GenCount[1,1] == "Blank")
{ 
Blank <<- GenCount[1,2]
}
if( GenCount[1,1] == "Block Caving")
{ 
BCG <<- GenCount[1,2]
}
if( GenCount[1,1] == "None")
{
NG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Open Pit")
{
OPG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[1,2] 
}




if( GenCount[2,1] == "Blank")
{ 
Blank <<- GenCount[2,2]
}
if( GenCount[2,1] == "Block Caving")
{ 
BCG <<- GenCount[2,2]
}
if( GenCount[2,1] == "None")
{
NG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Open Pit")
{
OPG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[2,2] 
}


if( GenCount[3,1] == "Blank")
{ 
Blank <<- GenCount[3,2]
}
if( GenCount[3,1] == "Block Caving")
{ 
BCG <<- GenCount[3,2]
}
if( GenCount[3,1] == "None")
{
NG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Open Pit")
{
OPG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[3,2] 
}


if( GenCount[4,1] == "Blank")
{ 
Blank <<- GenCount[4,2]
}
if( GenCount[4,1] == "Block Caving")
{ 
BCG <<- GenCount[4,2]
}
if( GenCount[4,1] == "None")
{
NG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Open Pit")
{
OPG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[4,2] 
}

## End gen count 































## count10
Dcat10count <<- count(Dcat10 , MT)
BC10 <<- 0
N10 <<- 0
OP10 <<- 0
RP10 <<- 0
VCR10 <<- 0



if( Dcat10count [1,1] == "Block Caving")
{ 
BC10 <<- Dcat10count [1,2]
}
if( Dcat10count [1,1] == "None")
{
N10 <<- Dcat10count [1,2] 
}
if( Dcat10count [1,1] == "Open Pit")
{
OP10  <<- Dcat10count [1,2] 
}
if( Dcat10count [1,1] == "Room-and-Pillar")
{
RP10  <<- Dcat10count [1,2] 
}
if( Dcat10count [1,1] == "Vertical Crater Retreat")
{
VCR10  <<- Dcat10count [1,2] 
}




if( Dcat10count [2,1] == "Block Caving")
{ 
BC10 <<- Dcat10count [2,2]
}
if( Dcat10count [2,1] == "None")
{
N10 <<- Dcat10count [2,2] 
}
if( Dcat10count [2,1] == "Open Pit")
{
OP10  <<- Dcat10count [2,2] 
}
if( Dcat10count [2,1] == "Room-and-Pillar")
{
RP10  <<- Dcat10count [2,2] 
}
if( Dcat10count [2,1] == "Vertical Crater Retreat")
{
VCR10  <<- Dcat10count [2,2] 
}




if( Dcat10count [3,1] == "Block Caving")
{ 
BC10 <<- Dcat10count [3,2]
}
if( Dcat10count [3,1] == "None")
{
N10 <<- Dcat10count [3,2] 
}
if( Dcat10count [3,1] == "Open Pit")
{
OP10  <<- Dcat10count [3,2] 
}
if( Dcat10count [3,1] == "Room-and-Pillar")
{
RP10  <<- Dcat10count [3,2] 
}
if( Dcat10count [3,1] == "Vertical Crater Retreat")
{
VCR10  <<- Dcat10count [3,2] 
}



if( Dcat10count [4,1] == "Block Caving")
{ 
BC10 <<- Dcat10count [4,2]
}
if( Dcat10count [4,1] == "None")
{
N10 <<- Dcat10count [4,2] 
}
if( Dcat10count [4,1] == "Open Pit")
{
OP10  <<- Dcat10count [4,2] 
}
if( Dcat10count [4,1] == "Room-and-Pillar")
{
RP10  <<- Dcat10count [4,2] 
}
if( Dcat10count [4,1] == "Vertical Crater Retreat")
{
VCR10  <<- Dcat10count [4,2] 
}

## End count 10


## count9
Dcat9count <<- count(Dcat9 , MT)
BC9 <<- 0
N9 <<- 0
OP9 <<- 0
RP9 <<- 0
VCR9 <<- 0


if( Dcat9count [1,1] == "Block Caving")
{ 
BC9 <<- Dcat9count [1,2]
}
if( Dcat9count [1,1] == "None")
{
N9 <<- Dcat9count [1,2] 
}
if( Dcat9count [1,1] == "Open Pit")
{
OP9  <<- Dcat9count [1,2] 
}
if( Dcat9count [1,1] == "Room-and-Pillar")
{
RP9  <<- Dcat9count [1,2] 
}
if( Dcat9count [1,1] == "Vertical Crater Retreat")
{
VCR9  <<- Dcat9count [1,2] 
}




if( Dcat9count [2,1] == "Block Caving")
{ 
BC9 <<- Dcat9count [2,2]
}
if( Dcat9count [2,1] == "None")
{
N9 <<- Dcat9count [2,2] 
}
if( Dcat9count [2,1] == "Open Pit")
{
OP9  <<- Dcat9count [2,2] 
}
if( Dcat9count [2,1] == "Room-and-Pillar")
{
RP9  <<- Dcat9count [2,2] 
}
if( Dcat9count [2,1] == "Vertical Crater Retreat")
{
VCR9  <<- Dcat9count [2,2] 
}




if( Dcat9count [3,1] == "Block Caving")
{ 
BC9 <<- Dcat9count [3,2]
}
if( Dcat9count [3,1] == "None")
{
N9 <<- Dcat9count [3,2] 
}
if( Dcat9count [3,1] == "Open Pit")
{
OP9  <<- Dcat9count [3,2] 
}
if( Dcat9count [3,1] == "Room-and-Pillar")
{
RP9  <<- Dcat9count [3,2] 
}
if( Dcat9count [3,1] == "Vertical Crater Retreat")
{
VCR9  <<- Dcat9count [3,2] 
}




if( Dcat9count [4,1] == "Block Caving")
{ 
BC9 <<- Dcat9count [4,2]
}
if( Dcat9count [4,1] == "None")
{
N9 <<- Dcat9count [4,2] 
}
if( Dcat9count [4,1] == "Open Pit")
{
OP9  <<- Dcat9count [4,2] 
}
if( Dcat9count [4,1] == "Room-and-Pillar")
{
RP9  <<- Dcat9count [4,2] 
}
if( Dcat9count [4,1] == "Vertical Crater Retreat")
{
VCR9  <<- Dcat9count [4,2] 
}

## End count 9

## count8
Dcat8count <<- count(Dcat8 , MT)
BC8 <<- 0
N8 <<- 0
OP8 <<- 0
RP8 <<- 0
VCR8 <<- 0



if( Dcat8count [1,1] == "Block Caving")
{ 
BC8 <<- Dcat8count [1,2]
}
if( Dcat8count [1,1] == "None")
{
N8 <<- Dcat8count [1,2] 
}
if( Dcat8count [1,1] == "Open Pit")
{
OP8  <<- Dcat8count [1,2] 
}
if( Dcat8count [1,1] == "Room-and-Pillar")
{
RP8  <<- Dcat8count [1,2] 
}
if( Dcat8count [1,1] == "Vertical Crater Retreat")
{
VCR8  <<- Dcat8count [1,2] 
}




if( Dcat8count [2,1] == "Block Caving")
{ 
BC8 <<- Dcat8count [2,2]
}
if( Dcat8count [2,1] == "None")
{
N8 <<- Dcat8count [2,2] 
}
if( Dcat8count [2,1] == "Open Pit")
{
OP8  <<- Dcat8count [2,2] 
}
if( Dcat8count [2,1] == "Room-and-Pillar")
{
RP8  <<- Dcat8count [2,2] 
}
if( Dcat8count [2,1] == "Vertical Crater Retreat")
{
VCR8  <<- Dcat8count [2,2] 
}


if( Dcat8count [3,1] == "Block Caving")
{ 
BC8 <<- Dcat8count [3,2]
}
if( Dcat8count [3,1] == "None")
{
N8 <<- Dcat8count [3,2] 
}
if( Dcat8count [3,1] == "Open Pit")
{
OP8  <<- Dcat8count [3,2] 
}
if( Dcat8count [3,1] == "Room-and-Pillar")
{
RP8  <<- Dcat8count [3,2] 
}
if( Dcat8count [3,1] == "Vertical Crater Retreat")
{
VCR8  <<- Dcat8count [3,2] 
}



if( Dcat8count [4,1] == "Block Caving")
{ 
BC8 <<- Dcat8count [4,2]
}
if( Dcat8count [4,1] == "None")
{
N8 <<- Dcat8count [4,2] 
}
if( Dcat8count [4,1] == "Open Pit")
{
OP8  <<- Dcat8count [4,2] 
}
if( Dcat8count [4,1] == "Room-and-Pillar")
{
RP8  <<- Dcat8count [4,2] 
}
if( Dcat8count [4,1] == "Vertical Crater Retreat")
{
VCR8  <<- Dcat8count [4,2] 
}


## End count 8

## count 7
Dcat7count <<- count(Dcat7 , MT)
BC7 <<- 0
N7 <<- 0
OP7 <<- 0
RP7 <<- 0
VCR7 <<- 0


if( Dcat7count [1,1] == "Block Caving")
{ 
BC7 <<- Dcat7count [1,2]
}
if( Dcat7count [1,1] == "None")
{
N7 <<- Dcat7count [1,2] 
}
if( Dcat7count [1,1] == "Open Pit")
{
OP7  <<- Dcat7count [1,2] 
}
if( Dcat7count [1,1] == "Room-and-Pillar")
{
RP7  <<- Dcat7count [1,2] 
}
if( Dcat7count [1,1] == "Vertical Crater Retreat")
{
VCR7  <<- Dcat7count [1,2] 
}



if( Dcat7count [2,1] == "Block Caving")
{ 
BC7 <<- Dcat7count [2,2]
}
if( Dcat7count [2,1] == "None")
{
N7 <<- Dcat7count [2,2] 
}
if( Dcat7count [2,1] == "Open Pit")
{
OP7  <<- Dcat7count [2,2] 
}
if( Dcat7count [2,1] == "Room-and-Pillar")
{
RP7  <<- Dcat7count [2,2] 
}
if( Dcat7count [2,1] == "Vertical Crater Retreat")
{
VCR7  <<- Dcat7count [2,2] 
}



if( Dcat7count [3,1] == "Block Caving")
{ 
BC7 <<- Dcat7count [3,2]
}
if( Dcat7count [3,1] == "None")
{
N7 <<- Dcat7count [3,2] 
}
if( Dcat7count [3,1] == "Open Pit")
{
OP7  <<- Dcat7count [3,2] 
}
if( Dcat7count [3,1] == "Room-and-Pillar")
{
RP7  <<- Dcat7count [3,2] 
}
if( Dcat7count [3,1] == "Vertical Crater Retreat")
{
VCR7  <<- Dcat7count [3,2] 
}





if( Dcat7count [4,1] == "Block Caving")
{ 
BC7 <<- Dcat7count [4,2]
}
if( Dcat7count [4,1] == "None")
{
N7 <<- Dcat7count [4,2] 
}
if( Dcat7count [4,1] == "Open Pit")
{
OP7  <<- Dcat7count [4,2] 
}
if( Dcat7count [4,1] == "Room-and-Pillar")
{
RP7  <<- Dcat7count [4,2] 
}
if( Dcat7count [4,1] == "Vertical Crater Retreat")
{
VCR7  <<- Dcat7count [4,2] 
}
## End count 7


## count 6
Dcat6count <<- count(Dcat6 , MT)
BC6 <<- 0
N6 <<- 0
OP6 <<- 0
RP6 <<- 0
VCR6 <<- 0


if( Dcat6count [1,1] == "Block Caving")
{ 
BC6 <<- Dcat6count [1,2]
}
if( Dcat6count [1,1] == "None")
{
N6 <<- Dcat6count [1,2] 
}
if( Dcat6count [1,1] == "Open Pit")
{
OP6  <<- Dcat6count [1,2] 
}
if( Dcat6count [1,1] == "Room-and-Pillar")
{
RP6  <<- Dcat6count [1,2] 
}
if( Dcat6count [1,1] == "Vertical Crater Retreat")
{
VCR6  <<- Dcat6count [1,2] 
}




if( Dcat6count [2,1] == "Block Caving")
{ 
BC6 <<- Dcat6count [2,2]
}
if( Dcat6count [2,1] == "None")
{
N6 <<- Dcat6count [2,2] 
}
if( Dcat6count [2,1] == "Open Pit")
{
OP6  <<- Dcat6count [2,2] 
}
if( Dcat6count [2,1] == "Room-and-Pillar")
{
RP6  <<- Dcat6count [2,2] 
}
if( Dcat6count [2,1] == "Vertical Crater Retreat")
{
VCR6  <<- Dcat6count [2,2] 
}




if( Dcat6count [3,1] == "Block Caving")
{ 
BC6 <<- Dcat6count [3,2]
}
if( Dcat6count [3,1] == "None")
{
N6 <<- Dcat6count [3,2] 
}
if( Dcat6count [3,1] == "Open Pit")
{
OP6  <<- Dcat6count [3,2] 
}
if( Dcat6count [3,1] == "Room-and-Pillar")
{
RP6  <<- Dcat6count [3,2] 
}
if( Dcat6count [3,1] == "Vertical Crater Retreat")
{
VCR6  <<- Dcat6count [3,2] 
}



if( Dcat6count [4,1] == "Block Caving")
{ 
BC6 <<- Dcat6count [4,2]
}
if( Dcat6count [4,1] == "None")
{
N6 <<- Dcat6count [4,2] 
}
if( Dcat6count [4,1] == "Open Pit")
{
OP6  <<- Dcat6count [4,2] 
}
if( Dcat6count [4,1] == "Room-and-Pillar")
{
RP6  <<- Dcat6count [4,2] 
}
if( Dcat6count [4,1] == "Vertical Crater Retreat")
{
VCR6  <<- Dcat6count [4,2] 
}
## End count 6

## count 5
Dcat5count <<- count(Dcat5 , MT)
BC5 <<- 0
N5 <<- 0
OP5 <<- 0
RP5 <<- 0
VCR5 <<- 0


if( Dcat5count [1,1] == "Block Caving")
{ 
BC5 <<- Dcat5count [1,2]
}
if( Dcat5count [1,1] == "None")
{
N5 <<- Dcat5count [1,2] 
}
if( Dcat5count [1,1] == "Open Pit")
{
OP5  <<- Dcat5count [1,2] 
}
if( Dcat5count [1,1] == "Room-and-Pillar")
{
RP5  <<- Dcat5count [1,2] 
}
if( Dcat5count [1,1] == "Vertical Crater Retreat")
{
VCR5  <<- Dcat5count [1,2] 
}



if( Dcat5count [2,1] == "Block Caving")
{ 
BC5 <<- Dcat5count [2,2]
}
if( Dcat5count [2,1] == "None")
{
N5 <<- Dcat5count [2,2] 
}
if( Dcat5count [2,1] == "Open Pit")
{
OP5  <<- Dcat5count [2,2] 
}
if( Dcat5count [2,1] == "Room-and-Pillar")
{
RP5  <<- Dcat5count [2,2] 
}
if( Dcat5count [2,1] == "Vertical Crater Retreat")
{
VCR5  <<- Dcat5count [2,2] 
}


if( Dcat5count [3,1] == "Block Caving")
{ 
BC5 <<- Dcat5count [3,2]
}
if( Dcat5count [3,1] == "None")
{
N5 <<- Dcat5count [3,2] 
}
if( Dcat5count [3,1] == "Open Pit")
{
OP5  <<- Dcat5count [3,2] 
}
if( Dcat5count [3,1] == "Room-and-Pillar")
{
RP5  <<- Dcat5count [3,2] 
}
if( Dcat5count [3,1] == "Vertical Crater Retreat")
{
VCR5  <<- Dcat5count [3,2] 
}




if( Dcat5count [4,1] == "Block Caving")
{ 
BC5 <<- Dcat5count [4,2]
}
if( Dcat5count [4,1] == "None")
{
N5 <<- Dcat5count [4,2] 
}
if( Dcat5count [4,1] == "Open Pit")
{
OP5  <<- Dcat5count [4,2] 
}
if( Dcat5count [4,1] == "Room-and-Pillar")
{
RP5  <<- Dcat5count [4,2] 
}
if( Dcat5count [4,1] == "Vertical Crater Retreat")
{
VCR5  <<- Dcat5count [4,2] 
}
## End count 5


## count 4
Dcat4count <<- count(Dcat4 , MT)
BC4 <<- 0
N4 <<- 0
OP4 <<- 0
RP4 <<- 0
VCR4 <<- 0



if( Dcat4count [1,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [1,2]
}
if( Dcat4count [1,1] == "None")
{
N4 <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Open Pit")
{
OP4  <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [1,2] 
}




if( Dcat4count [2,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [2,2]
}
if( Dcat4count [2,1] == "None")
{
N4 <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Open Pit")
{
OP4  <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [2,2] 
}




if( Dcat4count [3,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [3,2]
}
if( Dcat4count [3,1] == "None")
{
N4 <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Open Pit")
{
OP4  <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [3,2] 
}




if( Dcat4count [4,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [4,2]
}
if( Dcat4count [4,1] == "None")
{
N4 <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Open Pit")
{
OP4  <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [4,2] 
}
## End count 4 

## count 3
Dcat3count <<- count(Dcat3 , MT)
BC3 <<- 0
N3 <<- 0
OP3 <<- 0
RP3 <<- 0
VCR3 <<- 0


if( Dcat3count [1,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [1,2]
}
if( Dcat3count [1,1] == "None")
{
N3 <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Open Pit")
{
OP3  <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [1,2] 
}



if( Dcat3count [2,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [2,2]
}
if( Dcat3count [2,1] == "None")
{
N3 <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Open Pit")
{
OP3  <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [2,2] 
}


if( Dcat3count [3,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [3,2]
}
if( Dcat3count [3,1] == "None")
{
N3 <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Open Pit")
{
OP3  <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [3,2] 
}





if( Dcat3count [4,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [4,2]
}
if( Dcat3count [4,1] == "None")
{
N3 <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Open Pit")
{
OP3  <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [4,2] 
}
## End count 3 

## count 2
Dcat2count <<- count(Dcat2 , MT)
BC2 <<- 0
N2 <<- 0
OP2 <<- 0
RP2 <<- 0
VCR2 <<- 0


if( Dcat2count [1,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [1,2]
}
if( Dcat2count [1,1] == "None")
{
N2 <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Open Pit")
{
OP2  <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [1,2] 
}



if( Dcat2count [2,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [2,2]
}
if( Dcat2count [2,1] == "None")
{
N2 <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Open Pit")
{
OP2  <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [2,2] 
}



if( Dcat2count [3,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [3,2]
}
if( Dcat2count [3,1] == "None")
{
N2 <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Open Pit")
{
OP2  <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [3,2] 
}



if( Dcat2count [4,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [4,2]
}
if( Dcat2count [4,1] == "None")
{
N2 <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Open Pit")
{
OP2  <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [4,2] 
}
## End count 2 


## count 1
Dcat1count <<- count(Dcat1 , MT)
BC1 <<- 0
N1 <<- 0
OP1 <<- 0
RP1 <<- 0
VCR1 <<- 0


if( Dcat1count [1,1] == "Block Caving")
{ 
BC1 <<- Dcat1count [1,2]
}
if( Dcat1count [1,1] == "None")
{
N1 <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Open Pit")
{
OP1  <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Room-and-Pillar")
{
RP1  <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Vertical Crater Retreat")
{
VCR1  <<- Dcat1count [1,2] 
}




if( Dcat1count [2,1] == "Block Caving")
{ 
BC1 <<- Dcat1count [2,2]
}
if( Dcat1count [2,1] == "None")
{
N1 <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Open Pit")
{
OP1  <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Room-and-Pillar")
{
RP1  <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Vertical Crater Retreat")
{
VCR1  <<- Dcat1count [2,2] 
}



if( Dcat1count [3,1] == "Block Caving")
{ 
BC1 <<- Dcat1count [3,2]
}
if( Dcat1count [3,1] == "None")
{
N1 <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Open Pit")
{
OP1  <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Room-and-Pillar")
{
RP1  <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Vertical Crater Retreat")
{
VCR1  <<- Dcat1count [3,2] 
}



if( Dcat1count [4,1] == "Block Caving")
{ 
BC1 <<- Dcat1count [4,2]
}
if( Dcat1count [4,1] == "None")
{
N1 <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Open Pit")
{
OP1  <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Room-and-Pillar")
{
RP1  <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Vertical Crater Retreat")
{
VCR1  <<- Dcat1count [4,2] 
}

## End count 1 
#################################################### enmds dcat 1

TotalG <<-  (OPG + BCG+ NG + RPG + VCRG)
Total1 <<-  (OP1 + BC1 + N1 + RP1 + VCR1)
Total2 <<-  (OP2 + BC2 + N2 + RP2 + VCR2)
Total3 <<-  (OP3 + BC3 + N3 + RP3 + VCR3)
Total4 <<-  (OP4 + BC4 + N4 + RP4 + VCR4)
Total5 <<-  (OP5 + BC5 + N5 + RP5 + VCR5)
Total6 <<-  (OP6 + BC6 + N6 + RP6 + VCR6)
Total7 <<-  (OP7 + BC7 + N7 + RP7 + VCR7)
Total8 <<-  (OP8 + BC8 + N8 + RP8 + VCR8)
Total9 <<-  (OP9 + BC9 + N9 + RP9 + VCR9)
Total10 <<-  (OP10 + BC10 + N10 + RP10 + VCR10)

OPGPer <<- ((OPG/TotalG)*100)
OP1Per <<- ((OP1/Total1)*100)
OP2Per <<- ((OP2/Total2)*100)
OP3Per <<- ((OP3/Total3)*100)
OP4Per <<- ((OP4/Total4)*100)
OP5Per <<- ((OP5/Total5)*100)
OP6Per <<- ((OP6/Total6)*100)
OP7Per <<- ((OP7/Total7)*100)
OP8Per <<- ((OP8/Total8)*100)
OP9Per <<- ((OP9/Total9)*100)
OP10Per <<- ((OP10/Total10)*100)


BCGPer <<- ((BCG/TotalG)*100)
BC1Per <<- ((BC1/Total1)*100)
BC2Per <<- ((BC2/Total2)*100)
BC3Per <<- ((BC3/Total3)*100)
BC4Per <<- ((BC4/Total4)*100)
BC5Per <<- ((BC5/Total5)*100)
BC6Per <<- ((BC6/Total6)*100)
BC7Per <<- ((BC7/Total7)*100)
BC8Per <<- ((BC8/Total8)*100)
BC9Per <<- ((BC9/Total9)*100)
BC10Per <<- ((BC10/Total10)*100)

RPGPer <<- ((RPG/TotalG)*100)
RP1Per <<- ((RP1/Total1)*100)
RP2Per <<- ((RP2/Total2)*100)
RP3Per <<- ((RP3/Total3)*100)
RP4Per <<- ((RP4/Total4)*100)
RP5Per <<- ((RP5/Total5)*100)
RP6Per <<- ((RP6/Total6)*100)
RP7Per <<- ((RP7/Total7)*100)
RP8Per <<- ((RP8/Total8)*100)
RP9Per <<- ((RP9/Total9)*100)
RP10Per <<- ((RP10/Total10)*100)

VCRGPer <<- ((VCRG/TotalG)*100)
VCR1Per <<- ((VCR1/Total1)*100)
VCR2Per <<- ((VCR2/Total2)*100)
VCR3Per <<- ((VCR3/Total3)*100)
VCR4Per <<- ((VCR4/Total4)*100)
VCR5Per <<- ((VCR5/Total5)*100)
VCR6Per <<- ((VCR6/Total6)*100)
VCR7Per <<- ((VCR7/Total7)*100)
VCR8Per <<- ((VCR8/Total8)*100)
VCR9Per <<- ((VCR9/Total9)*100)
VCR10Per <<- ((VCR10/Total10)*100)

NGPer <<- ((NG/TotalG)*100)
N1Per <<- ((N1/Total1)*100)
N2Per <<- ((N2/Total2)*100)
N3Per <<- ((N3/Total3)*100)
N4Per <<- ((N4/Total4)*100)
N5Per <<- ((N5/Total5)*100)
N6Per <<- ((N6/Total6)*100)
N7Per <<- ((N7/Total7)*100)
N8Per <<- ((N8/Total8)*100)
N9Per <<- ((N9/Total9)*100)
N10Per <<- ((N10/Total10)*100)




Row2 <<- cbind(N1Per  )
Row3 <<- cbind(N2Per  )
Row4 <<- cbind(N3Per  )
Row5 <<- cbind(N4Per  )
Row6 <<- cbind(N5Per  )
Row7 <<- cbind(N6Per  )
Row8 <<- cbind(N7Per  )
Row9 <<- cbind(N8Per  )
Row10 <<-cbind(N9Per  )
Row11 <<-cbind(N10Per  )

  
NamesD <- c("Prob of Zero")
DataNew22 <- rbind(NamesD,Row2 ,Row3 ,Row4, Row5, Row6, Row7, Row8, Row9, Row10, Row11 )



NamesR <- c("Info",paste("Depth Level 1_", Group1,"_Meters",sep="") ,paste("Depth Level 2_", Group2,"_Meters",sep=""),paste("Depth Level 3_", Group3,"_Meters",sep=""), paste("Depth Level 4_", Group4,"_Meters",sep=""),paste("Depth Level 5_", Group5,"_Meters",sep=""),paste("Depth Level 6_", Group6,"_Meters",sep=""),paste("Depth Level 7_", Group7,"_Meters",sep=""),paste("Depth Level 8_", Group8,"_Meters",sep=""), paste("Depth Level 9_", Group9,"_Meters",sep=""), paste("Depth Level 10_", Group10,"_Meters",sep=""))

rownames(DataNew22) <- NamesR
#colnames(DataNew22) <- NamesD



OpenDS1 <<- paste("EF_06_10Depth_Stats_",TN1,".csv", sep = "")
OpenDS1b <<- read.csv(OpenDS1)

NewDS1B <<- cbind(OpenDS1b,DataNew22)


write.table(NewDS1B,sep = ",",file = OpenDS1, col.names = FALSE)


