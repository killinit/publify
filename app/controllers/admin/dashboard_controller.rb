# coding: utf-8
class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    t = Time.new
    today = t.strftime('%Y-%m-%d 00:00')

    # Since last venue
    @newposts_count = Article.published_since(current_user.last_venue).count
    @newcomments_count = Feedback.published_since(current_user.last_venue).count

    # Today
    @statposts = Article.published.where('published_at > ?', today).count
    @statsdrafts = Article.drafts.where('created_at > ?', today).count
    @statspages = Page.where('published_at > ?', today).count
    @statuses = Note.where('published_at > ?', today).count
    @statuserposts = Article.published.where('published_at > ?', today).count(conditions: { user_id: current_user.id })
    @statcomments = Comment.where('created_at > ?', today).count
    @presumedspam = Comment.presumed_spam.where('created_at > ?', today).count
    @confirmed = Comment.ham.where('created_at > ?', today).count
    @unconfirmed = Comment.unconfirmed.where('created_at > ?', today).count

    @comments = Comment.last_published
    @drafts = Article.drafts.where('user_id = ?', current_user.id).limit(5)

    @statspam = Comment.spam.count
    @inbound_links = inbound_links
    @publify_links = publify_dev
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host
    return [] if Rails.env.development?
    url = "http://www.google.com/search?q=link:#{host}&tbm=blg&output=rss"
    parse(url).reverse.compact
  end

  def publify_dev
    url = 'http://blog.publify.co/articles.rss'
    parse(url)[0..2]
  end

  def parse(url)
    open(url) do |http|
      return parse_rss(http.read)
    end
  rescue
    []
  end

  class RssItem < Struct.new(:link, :title, :description, :description_link, :date, :author)
    def to_s; title end
  end

  def parse_rss(body)
    xml = REXML::Document.new(body.force_encoding('ISO-8859-1').encode('UTF-8'))

    items        = []
    link         = REXML::XPath.match(xml, '//channel/link/text()').first.value rescue ''
    title        = REXML::XPath.match(xml, '//channel/title/text()').first.value rescue ''

    REXML::XPath.each(xml, '//item/') do |elem|
      item = RssItem.new
      item.title       = REXML::XPath.match(elem, 'title/text()').first.value rescue ''
      item.link        = REXML::XPath.match(elem, 'link/text()').first.value rescue ''
      item.description = REXML::XPath.match(elem, 'description/text()').first.value rescue ''
      item.author      = REXML::XPath.match(elem, 'dc:publisher/text()').first.value rescue ''
      item.date        = Time.mktime(*ParseDate.parsedate(REXML::XPath.match(elem, 'dc:date/text()').first.value)) rescue Date.parse(REXML::XPath.match(elem, 'pubDate/text()').first.value) rescue Time.now

      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, '') # remove all <a> tags
      items << item
    end

    items
  end
end
