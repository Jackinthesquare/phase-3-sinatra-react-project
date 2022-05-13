class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "WELCOME TO MY SINATRA-REACT PROJECT" }.to_json
  end

  ### DO NOT TOUCH OR VISIT END POINT OR YOU WILL BE FIRED!
  get "/fetch_pokellector" do ### scrapes data and assign it to a table
    url = 'https://www.pokellector.com/sets/BS-Base-Set'
    html = Nokogiri::HTML5(URI.open(url))
    
    listingArr = html.css('div.plaque').collect.with_index { |el, index|
      # p el.text #test to see what the element was
      # p "******"
      Pokemon.create(
        {
          scraped_element: el.content,
          cardName: el.text.gsub!(/\d+/,"").tr("[#", "").tr("-", "").strip,
          set_num: index + 1,
          imgSrc: "https://den-cards.pokellector.com/119/#{el.text.gsub!(/\d+/,"").tr("[#", "").tr("-", "").strip.gsub(' ','-').gsub("'","")}.BS.#{index+1}.png"
        }
      )
    }

    # listingArr.each { |el|
    #   el.update(
    #       imgSrc: "https://den-cards.pokellector.com/119/#{el.cardName.gsub(' ','-').gsub("'","")}.BS.#{el.set_num}.png"
    #   )
    # }
    # listingArr.to_json

    # listingArr.each { |el|
    #   el.imgSrc = "https://den-cards.pokellector.com/119/#{el.cardName.gsub(' ','-').gsub("'","")}.BS.#{el.set_num}.png"
    # }
    { cardList: listingArr }.to_json    
  end
  ### DO NOT TOUCH OR VISIT END POINT OR YOU WILL BE FIRED!


  get "/cards" do ### shows list of cards scraped from Pokellector
    cards = Pokemon.all
    { cardList: cards }.to_json
  end


  get "/cards/:id" do
    cards = Pokemon.find(params[:id])
    cards.to_json
  end

  delete '/cards/:id' do
    cards = Pokemon.find(params[:id])
    cards.destroy
  end

  post '/cards' do
    cards = Pokemon.create(cardName:params[:cardName], set_num:params[:set_num], imgSrc:params[:imgSrc])
    cards.to_json
  end

  # patch '/cards/:id' do
  # cards = Pokemon.update(cardName:params[:cardName], set_num:params[:set_num], imgSrc:params[:imgSrc])
  # cards.to_json
  # end
end
