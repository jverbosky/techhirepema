require "sinatra"
require "pg"
require_relative "add_form.rb"
require_relative "return_data.rb"

class AcesApp < Sinatra::Base

  get "/" do
    feedback = ""
  	erb :starter, locals: {feedback: feedback}
  end

  post '/commit_form' do
    feedback = validate_file(params[:user])
    if feedback == ""
      add_form(params[:user])
      write_image(params[:user])
      redirect to '/'
    else
      erb :starter, locals: {feedback: feedback}
    end
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
    feedback = ""
    vals = params[:vars]
    h = {}
    vals.split(',').each do |substr|
      ary = substr.strip.split('=>')
      h[ary.first.tr('\'','')] = ary.last.tr('\'','')
    end
    image = pull_image(h["name"])
    erb :update_form, :locals => {results: h, image: image, feedback: feedback}
  end

  post '/commit_updates' do
    feedback = validate_file(params[:user])
    if feedback == ""
      update_values(params[:user])
      write_image(params[:user])
      redirect to "/"
    else
      image = pull_image(params[:user]["name"])
      erb :update_form, locals: {results: params[:user], image: image, feedback: feedback}
    end
  end

end