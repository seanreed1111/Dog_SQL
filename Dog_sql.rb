require 'mysql2'

class Dog
	attr_accessor :name, :color, :id

	@@db = Mysql2::Client.new(:host=>'192.168.2.2',
								:username=>'student', 
								:password=>'mypass',
								:database=>'dogs')

	def initialize(name, color)
		@name = name
		@color = color
	end

	def db
		@@db
	end

	def self.db
		@@db
	end


	def mark_as_saved!
		self.id = self.db.last_id if self.db.last_id >0
	end

	def insert
		db.query("
		INSERT INTO dogs (name, color)
		VALUES ('#{self.name}', '#{self.color}')
		")
		self.mark_as_saved!
	end


	def self.find(id)
		results = db.query("
			SELECT * 
			FROM dogs
			WHERE id = #{id}"
		)
		if results.first.nil?
			"whimper"
		else
		self.new_from_db(results.first)
		end

	end

	def self.find_by_name(name)
		self.db.query("
			SELECT *
			FROM dogs
			where name = '#{name}'
		")

		if results.first.nil?
			return "whimper"
		else
			return self.new_from_db(results.first) #return self.wrap_results
		end
	end

	def self.wrap_results

	end

	# what about the DB id?
	#if it exists in Ruby, that means the dog exists in the database

	def update
		self.db.query("
			UPDATE dogs
			SET name = '#{self.name}', color = '#{self.color}'
			WHERE id = self.id
		")
	end


	def save
		self.saved? ? self.update : self.insert
	end

	def saved?
		self.id.nil? ? return false : return true
	end

	def self.new_from_db(row)
		dog = Dog.new(row["name"], row["color"])
		dog.id = row["id"]
		dog
	end

	def find_by_name(name)
		db.query("
			SELECT *
			FROM dogs
			WHERE name = #{name}"
		)
	end

	def find_by_color(color)
		db.query("
			SELECT *
			FROM dogs
			WHERE color = '#{color}'
		
		")
	end

	def inspect
		"I am a dog, you, my name is #{self.name}"
	end

	def ==(other_dog)
		self.id == other_dog.id
	end

end

