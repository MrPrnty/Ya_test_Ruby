Given("Открыть в браузере yandex.ru") do
    @driver.get('http://www.yandex.ru')
    @driver.manage().window().maximize()
end

When("Нажать на {string}") do |string|
    el = @driver.find_element(link_text: string)
    el if el && el.displayed?
        el.click
end

When("Ввести цену от {string} рублей") do |string|
    el = @driver.find_element(name: "glf-pricefrom-var")
    el.clear
    el.send_keys string
end

When("Проверить количество элементов на странице") do
    els = @driver.find_elements(class: "n-snippet-cell2__title")
    if els.size == 12
        puts "Элементов на странице: " + els.size.to_s
    else
        puts "Элементов на странице не 12 (" + els.size.to_s + ")!"
    end
end

When("Запомнить первый элемент") do
    f_el = @driver.find_element(class: "n-snippet-cell2").freeze
    $f_el_name = @driver.find_element(class: "n-snippet-cell2").find_element(class: "n-snippet-cell2__title").text.freeze
    $f_el_price = @driver.find_element(class: "n-snippet-cell2").find_element(class: "price").text.gsub(/\D/,"").freeze
    puts $f_el_name
    puts $f_el_price
    
end

When("Найти запомненное значение") do
    unless $f_el_name.nil? || $f_el_name == ""
        el = @driver.find_element(id: "header-search")
        el.send_keys($f_el_name)
        el.submit
        begin    
            @driver.find_element(class: "n-snippet-list")
            el = @driver.find_element(link_text: $f_el_name)
            el if el && el.displayed?
                el.click
        rescue Selenium::WebDriver::Error::NoSuchElementError 
        end
    end
end

When("Сравнить запомненное значение с найденным") do
    @wait.until {@driver.find_element(class: "n-title__text")}
    el = @driver.find_element(class: "n-title__text")
    el if el && el.displayed?
        el_name = el.text   
    if el_name == $f_el_name
        puts "Элементы совпадают"
    else
        puts "Элементы не совпадают"
        puts el_name + " != " + $f_el_name
    end
end

When("Проверить сортировку") do
    @wait.until {@driver.find_element(class: "n-snippet-cell2__main-price").text.gsub(/\D/,"") != $f_el_price}
    els = @driver.find_elements(class: "n-snippet-cell2__main-price")
    flag=true
    unless els.size.nil?
        pr_el_price = els[0].text.gsub(/\D/,"")
        for i in 1..els.size-1
            if pr_el_price.to_i > els[i].text.gsub(/\D/,"").to_i
                puts pr_el_price + " > " + els[i].text.gsub(/\D/,"")
                flag=false
                break    
            end 
            pr_el_price = els[i].text.gsub(/\D/,"")  
        end
    end
    if flag
        puts "Элементы на странице отсортированы верно."
    else
        puts "Элементы на странице отсортированы неверно!"
    end
end
