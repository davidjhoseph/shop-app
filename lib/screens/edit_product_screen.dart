import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();

  var _initialValues = {
    'id': '',
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  var _product = Product(
    id: null,
    description: '',
    title: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  var _isinit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isinit) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValues = {
          'id': _product.id,
          'title': _product.title,
          'price': _product.price.toString(),
          'description': _product.description,
          'imageUrl': ''
        };
        _imageUrlController.text = _product.imageUrl;
      }
    }
    _isinit = false;
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _submitForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_product.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_product.id, _product);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_product);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initialValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _product = Product(
                        id: _product.id,
                        isFavorite: _product.isFavorite,
                        title: value,
                        description: '',
                        imageUrl: '',
                        price: 0);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a price!';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number!';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please provide a price greater than zero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      isFavorite: _product.isFavorite,
                      title: _product.title,
                      description: '',
                      imageUrl: '',
                      price: double.parse(value),
                    );
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  initialValue: _initialValues['description'],
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a Description!';
                    }
                    if (value.length < 10) {
                      return 'Please enter a lengthy description!';
                    }

                    return null;
                  },
                  maxLines: 3,
                  onSaved: (value) {
                    _product = Product(
                        id: _product.id,
                        isFavorite: _product.isFavorite,
                        title: _product.title,
                        description: value,
                        imageUrl: '',
                        price: _product.price);
                  },
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                              child: Text(
                                'Enter a URL',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide an image Url!';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please provide a valid URL';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            isFavorite: _product.isFavorite,
                            title: _product.title,
                            description: _product.description,
                            imageUrl: value,
                            price: _product.price,
                          );
                        },
                        onFieldSubmitted: (_) {
                          _submitForm();
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    )
                  ],
                ),
                RaisedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
