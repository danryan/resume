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
    attr_accessor :name, :skills, :experience, :summary, :objective
    
    def initialize() @name = "Dan Ryan"; @experience, @skills = [], []; @objective, @summary = "", ""; end
    def experience=(job) @experience << job; end
    def name() "# #{@name}\n"; end
    def objective() @objective; end
    def objective=(obj) @objective = Objective.new(obj); end
    def summary() @summary; end
    def summary=(obj) @summary = Summary.new(obj); end
    
    def to_s
      res = ""
      res << name
      res << "\n"
      res << "## Objective\n"
      res << objective.to_s
      res << "\n\n"
      res << "## Relevant Skills\n"
      skills.each do |s|
        res << s.to_s
      end
      res << "\n"
      res << "## Experience\n"
      # res << "\n"
      experience.each do |e|
        res << e.to_s
      end
      res << "\n"
      res << "## Summary\n"
      res << summary.to_s
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
    attr_accessor :start_date, :end_date, :title, :company, :summary
    def initialize() @start_date, @end_date, @title, @company, @summary = "", "", "", "", ""; end
    def work() yield self; self; end
    def to_s() %{### #{@title}\n#### #{@company} - #{@start_date} to #{end_date}\n\n}; end
  end

  class Summary
    def initialize(text) @text = text; end    
    def to_s() @text; end
  end

end

resume = DanRyan::Resume.new
resume.objective = "I seek the Grail."

resume.build_experience do |experience|
  experience.employment do |employment|
    employment.company = "Liquid Web, Inc."
    employment.title = "System Administrator, Project/Support/Training Manager, Developer"
    employment.start_date = Date.civil(2007, 5)
    employment.end_date = "Present"
    employment.summary = ""
  end
  experience.employment do |employment|
    employment.company = "DecisionOne, Inc."
    employment.title = "Project Manager, System Administrator, Field Technician"
    employment.start_date = Date.civil(2005, 2)
    employment.end_date = Date.civil(2007, 5)
    employment.summary = ""
  end
end

resume.build_skills do |skill|
  skill.value = "Shell scripting and automation"
  skill.value = "Linux system administration"
  skill.value = "Web hosting configuration and maintenance"
  skill.value = "Database administration and optimization"
  skill.value = "Virtualization (Xen & KVM)"
  skill.value = "Ruby development"
  skill.value = "Web design and development"
  skill.value = "Hardware design, implementation and management"
end

resume.summary = "Hire me!"

puts resume.to_s
puts RDiscount.new(resume.to_s).to_html
