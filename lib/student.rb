require_relative "../config/environment.rb"

class Student

attr_accessor :name, :grade, :id

def initialize(name, grade, id = nil)
  @id = id
  @name = name
  @grade = grade
end

def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
  )
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
  sql = "DROP TABLE IF EXSTS students"
  DB[:conn].execute(sql)
end

def save
  if self.id
      self.update
  else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end
end

def self.create(name, grade)
  student = Student.new(name: name, grade: grade)
  student.save
end

def self.new_from_db(row)
  self.new(id: row[0], name: row[1], grade: rwo[2])
end 

def self.find_by_name(name)
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE students.name = ?
  LIMIT 1
  SQL

  DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
  end.first
end

  def update
    sql = <<-SQL
    UPDATE students
    SET
    name =?,
    grade = ?
    WHERE id = ?
    SQL

    DB[conn:].execute(sql, self.name, self.breed, self.id)
  end
end
