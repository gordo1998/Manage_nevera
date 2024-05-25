

class Product{
  String _title;
  String _image;
  String _id;
  bool _selected = false;


  Product(this._title, this._image, this._id);

  String getTitle(){
    return _title;
  }

  String getImage(){
    return _image;
  }

  String getId(){
    return _id;
  }

  void setSelection(bool selection){
    _selected = selection;
  }

  bool getSelection(){
    return _selected;
  }
}
