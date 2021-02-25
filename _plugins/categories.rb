module Jekyll

  class CategoryPageGenerator < Generator
    safe true
    require 'yaml'


    def generate(site)
      content_categories = YAML.load_file "content_categories.yml"
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'category'
        content_categories.each do |name, category|
           # puts "Look here #{name.keys.join()}"
            category_folder = name.keys.join().gsub(" ", "-").downcase
            site.pages << CategoryPage.new(site, site.source, File.join(dir, category_folder), category_folder) 
                        
          category.values.each do |cat|
            cat.each do |sub_cat|
            #  puts sub_cat.values[0]
              sub_category_folder = sub_cat.values[0].gsub(" ", "-").downcase
              site.pages << CategoryPage.new(site, site.source, File.join(dir, "#{category_folder}/#{sub_category_folder}"), sub_category_folder)                           
              sub_cat.values[1].each do |subcat_list|
              #  puts subcat_list
              #  puts "XXXXXXX #{subcat_list.values[0]}"
                subcat_list_folder = subcat_list.values[0].gsub(" ", "-").downcase
                site.pages << CategoryPage.new(site, site.source, File.join(dir, "#{category_folder}/#{sub_category_folder}/#{subcat_list_folder}"), subcat_list_folder)
              end
            end
          end
        end
      end
    end
  end

  # A Page subclass used in the `CategoryPageGenerator`
  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix']# || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end
end

