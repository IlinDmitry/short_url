# frozen_string_literal: true

class UrlsController < ApplicationController
  def show
    set_url
    if @url.present?
      @url.increase_stats!
      render json: @url.to_json(only: [:original_url])
    else
      render json: @url, status: :unprocessable_entity
    end
  end

  def create
    @url = Url.find_or_initialize_by(original_url: short_url_params[:original_url])

    if @url.save
      render json: @url, status: :created, location: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  def stats
    stats_from_cache = Url.get_stats(short_url)
    if stats_from_cache.present?
      render json: { stats: stats_from_cache }
    else
      render json: @url, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_url
    @url = Url.find_by(short_url: short_url)
  end

  def short_url
    return short_url_params[:id] if short_url_params[:id].present?

    short_url_params[:short_url]
  end

  # Only allow a trusted parameter "white list" through.
  def short_url_params
    params.permit(:id, :original_url, :short_url)
  end
end
