import psycopg2
import xml.sax
from sets import Set
#Question 1: Create three tables and insert required rows into according tables
#Connect to the database
connect = psycopg2.connect(database="postgres", user="postgres")
print "Successfully connect to the database"

global count
count=0
#Create a cursor
cursor=connect.cursor()

#Create tables
cursor.execute('CREATE TABLE Article(pubkey varchar PRIMARY KEY, title varchar, journal varchar, year int)')

cursor.execute('CREATE TABLE Inproceedings(pubkey varchar PRIMARY KEY, title varchar, booktitle varchar, year int)')

cursor.execute('CREATE TABLE Authorship(pubkey varchar, authorname varchar, PRIMARY KEY(pubkey,authorname))')

print "Successfully create tables"

#define fileHandler
class fileHandler(xml.sax.ContentHandler):
  def __init__(self):
    self.tag=""
    self.pubkey=""

    self.title=""
    self.journal=""
    self.booktitle=""
    self.year=""

    self.author=""
    self.authorList=Set()
    self.enter=False

  #call when start an attribute starts
  def startElement(self,tag,attributes):
    validTag=["article","author","inproceedings","title","journal","year","booktitle"]
    if tag in validTag:
      self.tag=tag

    if(tag=="author"):
      self.author=""

    if(tag=="title"):
      self.title=""

    if(tag=="journal"):
      self.journal=""

    if(tag=="year"):
      self.year=""

    if(tag=="booktitle"):
      self.booktitle=""

    if(tag=="article" or tag=="inproceedings"):
      self.enter=True
      self.pubkey=attributes["key"]
      self.title=""
      self.journal=""
      self.booktitle=""
      self.year=""
      self.author=""
      self.authorList=Set()

  #call when stop an attribute
  def endElement(self,tag):
    validTag=["article","author","inproceedings","title","journal","year","booktitle"]
    if tag in validTag:
      #insert into "article" table
      if (tag=="article"):
        list1=[self.pubkey,self.title,self.journal,self.year]
        for i in range(len(list1)):
          if(list1[i]==""):
            list1[i]=None
      
        tuple1=(list1[0],list1[1],list1[2],list1[3])
        global count
        if(count%5000==0):
            print tuple1
        cursor.execute('INSERT INTO Article(pubkey,title,journal,year) VALUES (%s,%s,%s,%s)',tuple1)

      #insert into "inproceedings" table
      elif (tag=="inproceedings"):
        list2=[self.pubkey,self.title,self.booktitle,self.year]
        for i in range(len(list2)):
          if(list2[i]==""):
            list2[i]=None

        tuple1=(list2[0],list2[1],list2[2],list2[3]) 
        global count
        if(count%5000==0):
            print tuple1
        cursor.execute('INSERT INTO Inproceedings(pubkey,title,booktitle,year) VALUES (%s,%s,%s,%s)',tuple1)

      #read author into self.authorList
      elif(tag=="author"):
        self.authorList.add(self.author)
        self.author=""

    #insert into "authorship" table
      if(tag=="article" or tag=="inproceedings"):
        global count
        for elem in self.authorList:
          tuple2=(self.pubkey,elem)
          if(count%5000==0):
              print tuple2
          cursor.execute('INSERT INTO Authorship(pubkey,authorname) VALUES (%s,%s)',tuple2)
        self.authorList=Set()
        self.enter=False
        count = count+1
 
    self.tag=""
    

  #call each time when read character
  def characters(self, content):
      if(self.enter):
          if(self.tag=="title"):
            self.title=self.title+content

          if(self.tag=="journal"):
            self.journal=self.journal+content

          if(self.tag=="booktitle"):
            self.booktitle=self.booktitle+content

          if(self.tag=="year"):
            self.year=self.year+content

          if(self.tag=="author"):
            self.author=self.author+content

#parse the file
parser = xml.sax.make_parser()
parser.setFeature(xml.sax.handler.feature_namespaces, 0)
handler=fileHandler()
parser.setContentHandler(handler)
parser.parse("dblp-2015-12-01.xml")
print "successfully parse file"

#store changes to database
connect.commit()
cursor.close()
connect.close()



