require 'spec_helper'
require 'everywhere/hash_value'

describe 'normal query' do
  before do
    @where = Post.where(:title => 'hello').where_values
  end
  subject { @where }
  it { @where.should have(1).item }
  subject { @where.first }
  its(:to_sql) { should == %q["posts"."title" = 'hello'] }
end

describe 'not' do
  describe 'not eq' do
    before do
      @where = Post.where(:title => {:not => 'hello'}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" != 'hello'] }
  end

  describe 'not null' do
    before do
      @where = Post.where(:created_at => {:not => nil}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."created_at" IS NOT NULL] }
  end

  describe 'not in' do
    before do
      @where = Post.where(:title => {:not => %w[hello goodbye]}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT IN ('hello', 'goodbye')] }
  end

  describe 'association' do
    before do
      @where = Post.joins(:comments).where(:comments => {:body => {:not => 'foo'}}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["comments"."body" != 'foo'] }
  end
end

describe 'like' do
  describe 'like match' do
    before do
      @where = Post.where(:title => {:like => 'he%'}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" LIKE 'he%'] }
  end
end

describe 'not like' do
  describe 'not like match' do
    before do
      @where = Post.where(:title => {:not_like => 'he%'}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT LIKE 'he%'] }
  end
end
