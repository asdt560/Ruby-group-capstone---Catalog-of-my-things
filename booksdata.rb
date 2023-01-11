require 'json'
require_relative 'book'

module BooksData
  def write_json(array, file_path)
    File.write(file_path, JSON.pretty_generate(array))
  end

  def read_json(file_path)
    return [] unless File.exist?(file_path)

    file = File.read(file_path)
    JSON.parse(file)
  end

  def save_books
    array = read_json('./JSON_data/books.json')
    list_id = []
    array.each { |book| list_id.push(book['id']) }
    @booklist.each do |book|
      next if list_id.include?(book.id)

      if book.label.nil?
        array.push(
          { name: book.name, publisher: book.publisher, cover_state: book.cover_state,
            published_date: book.published_date, label: book.label.id, id: book.id, archived: book.archived }
        )
      else
        array.push(
          { name: book.name, publisher: book.publisher, cover_state: book.cover_state,
            published_date: book.published_date, label: nil, id: book.id, archived: book.archived }
        )
      end
    end
    write_json(array, './JSON_data/books.json')
  end

  def load_books
    parse_file = read_json('./JSON_data/books.json')
    parse_file.each do |book|
      correctlabel = @labellist.find { |label| label.id == book['label'] }
      loadedbook = Book.new(book['name'], book['publisher'], book['cover_state'], book['published_date'],
                            id: book['id'], archived: book['archived'])
      @booklist.push(loadedbook)
      loadedbook.add_label(correctlabel)
    end
  end
end