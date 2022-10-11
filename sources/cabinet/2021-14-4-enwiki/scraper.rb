#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Duration')]][last()]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.css('a/@wikidata').first
    end

    field :name do
      name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      tds[1].text
        .gsub('President of Kim Il Sung University', '')
        .gsub('ProtectionChairman of the Supervisory Bureau of Forestry Policy of the State Affairs Commission', '')
        .tidy
    end

    field :startDate do
      WikipediaDate.new(raw_start).to_s
    end

    field :endDate do
    end

    private

    def tds
      noko.css('td,th')
    end

    def name_node
      tds[2]
    end

    def raw_start
      tds[4].text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
