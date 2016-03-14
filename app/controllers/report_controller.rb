class ReportController < ApplicationController
  def index
    date_query_string = generate_date_query_string(params)
    region_query_string = generate_region_query_string(params)
    query_hash = generate_query_hash(params)
    @sightings = query_sightings(date_query_string,
                                 region_query_string,
                                 query_hash)
  end

  private

  def generate_date_query_string(params)
    start_date = params[:start_date]
    end_date = params[:end_date]

    date_query_strings = []
    date_query_strings.push('date >= :start_date') if start_date.present?
    date_query_strings.push('date <= :end_date') if end_date.present?

    if date_query_strings.length > 1
      date_query_strings.join(' AND ')
    else
      date_query_strings[0]
    end
  end

  def generate_region_query_string(params)
    region_id = params[:region_id]
    'region_id = :region_id' if region_id.present?
  end

  def generate_query_hash(params)
    start_date = params[:start_date]
    end_date = params[:end_date]
    region_id = params[:region_id]
    query_hash = {}
    query_hash[:start_date] = start_date if start_date.present?
    query_hash[:end_date] = end_date if end_date.present?
    query_hash[:region_id] = region_id if region_id.present?
    query_hash
  end

  def query_sightings(date_query_string, region_query_string, query_hash)
    if date_query_string.present? && region_query_string.present?
      query_string = [date_query_string, region_query_string].join(' AND ')
      Sighting.where(query_string, query_hash)
    elsif date_query_string.present?
      Sighting.where(date_query_string, query_hash)
    elsif region_query_string.present?
      Sighting.where(region_query_string, query_hash)
    else
      Sighting.all
    end
  end
end
