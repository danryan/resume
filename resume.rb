# /usr/bin/env ruby

# This resume is viewable in multiple formats:
# * Markdown
# * PDF
# * YAML
# * HTML
# * Manpage
# * RDoc

# This resume requires the following libraries to properly display:
# * RDiscount
# * Thor
#
# For additional formats, the following libraries are necessary
# * Prince
# * YAML
# * YARD

require 'rubygems'
require 'rdiscount'

module DanRyan
  class Resume
    attr_accessor :skills, :experience, :summary, :objective
    
    def initialize
      @name = "Dan Ryan"; 
      @experience, @skills = [], []
      @objective, @summary = "", ""
      @name = "Dan Ryan"
      @address = "2241 Cumberland Rd."
      @city = "Lansing"
      @state = "MI"
      @zip = "48911"
      @phone = "(517) 214-5853"
      @email = "scriptfu@gmail.com"  
    end
    def experience=(job) @experience << job; end
    def objective=(obj) @objective = Objective.new(obj); end
    def summary=(obj) @summary = Summary.new(obj); end
    
    def to_s
      res = "# #{@name}\n"
      res << "* #{@address}\n* #{@city}, #{@state} #{@zip}\n* scriptfu@gmail.com\n* #{@phone}"
      res << "\n"
      res << ""
      res << "\n\n"
      res << "## Objective\n"
      res << objective.to_s
      res << "\n"
      res << "## Summary\n"
      res << summary.to_s
      res << "\n"
      res << "## Relevant Skills\n\n"
      skills.each do |s|
        res << s.to_s
      end
      res << "\n"
      res << "## Experience\n\n"
      # res << "\n"
      experience.each do |e|
        res << e.to_s
        res << e.highlights
        res << "\n\n"
      end
      res
    end
    
    
    %w(experience skills).each do |name|
      class_eval <<-END
        def add_#{name}(obj) self.#{name} << obj; end
        def build_#{name}() yield self if block_given?; self; end
      END
    end

    def employment() job = Experience.new; yield job; self.add_experience(job); end
    def value=(skill) s = Skill.new(skill); self.add_skills(s); end
  end

  class Objective
    def initialize(text) @text = text; end
    def to_s() "#{@text}"; end
  end

  class Skill
    def initialize(kind) @kind = kind; end
    def to_s() "* #{@kind}\n"; end
  end

  class Experience
    attr_accessor :start_date, :end_date, :title, :company, :summary, :highlights
    def initialize() @start_date, @end_date, @title, @company, @summary, @highlights = "", "", "", "", "", ""; end
    def work() yield self; self; end
    def to_s() %{### #{@title}\n#### #{@company} - #{@start_date} to #{end_date}\n}; end
  end

  class Summary
    def initialize(text) @text = text; end    
    def to_s() @text; end
  end

end

resume = DanRyan::Resume.new
resume.summary = "
I am passionate about learning in all its aspects, from self-study, to training a classroom of students, to experiencing the life lessons that every day brings.  There is no greater joy than helping others understand. 

I am a geek.  I can spend 8 hours in front of a computer at work, and happily pick up right where I left off at home.  I am a gamer.  I enjoy games of all genres, but am particularly fond of indie games.  I am a comedian. 


I am an optimist.  We are capable of amazing things when we have the right attitude and encouragement.


"
resume.objective = "
I seek a small company with big dreams.  I want a challenging position that will push my abilities.  I want to work for a company that builds strong relationships with its employees; a company recognizes and fosters excellence; and a company that will empower me to grow alongside them.  Given what I have seen and heard all that Elevator Up has done, I have found the company I am looking for is you.
"

resume.build_skills do |skill|
  skill.value = "Linux system administration"
  skill.value = "Web hosting"
  skill.value = "Database administration and optimization"
  skill.value = "Virtualization (Xen & KVM)"
  skill.value = "Shell scripting and automation"
  skill.value = "Ruby development"
  skill.value = "Web design and development"
  skill.value = "Hardware design, implementation and management"
end

resume.build_experience do |experience|
  experience.employment do |employment|
    employment.company = "Liquid Web, Inc."
    employment.title = "System Administrator, Project/Support/Training Manager, Developer"
    employment.start_date = Date.civil(2007, 5)
    employment.end_date = "Present"
    employment.highlights = "
I manage 150+ employees in the support department across three datacenters, which is the largest department in the company, as well as our primary product.  I devised and implemented an organizational restructure to improve efficiency and, more importantly, the company's atmosphere and culture. 
    
I also manage the training department, where I am responsible for hiring, developing and mentoring a highly-skilled workforce.  I created a comprehensive training program capable of turning people with no prior Linux experience into very qualified and capable system administrators.  
    
In addition, I am charged with the development and oversight of new products and improving existing infrastructure.  I successfully launched an external knowledge base that increased revenue by improving search engine rankings and our online presence.  

On the marketing side, I maintain our websites for [Liquid Web](http://liquidweb.com) and [Storm on Demand](http://www.stormondemand.com). I write the copy for promotional material, represent Liquid Web at conferences, and monitor our brand reputation across all major and social media outlets."
  end
  experience.employment do |employment|
    employment.company = "DecisionOne, Inc."
    employment.title = "Project Manager, System Administrator, Field Technician"
    employment.start_date = Date.civil(2005, 2)
    employment.end_date = Date.civil(2007, 5)
    employment.highlights
  end
end




puts resume.to_s
puts RDiscount.new(resume.to_s).to_html
