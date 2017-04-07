require "sinatra"
require "pg"
require_relative "add_form.rb"
require_relative "return_data.rb"

class AcesApp < Sinatra::Base

  get "/" do

  	erb :starter
  end

  post '/commit_form' do
    add_form(params[:user])
    write_image(params[:user])
    redirect to '/'
  end

  get '/search' do
    feedback = ""
    erb :search, locals: {feedback: feedback}
  end

  post '/search_results' do
    value = params[:name]
    results = pull_records(value)  # get array of hashes for all matching records
    feedback = results[0]["name"]
    if feedback == "No matching record - please try again."
      erb :search, locals: {feedback: feedback}
    else
      erb :search_results, locals: {results: results}
    end
  end

  post '/update_form' do
    vals = params[:vars]
    h = {}
    vals.split(',').each do |substr|
      ary = substr.strip.split('=>')
      h[ary.first.tr('\'','')] = ary.last.tr('\'','')
    end
    image = pull_image(h["name"])
    erb :update_form, :locals => {results: h, image: image}
  end

  post '/commit_updates' do
    user_hash = params[:user]
    update_values(user_hash)
    redirect to "/"
  end
end