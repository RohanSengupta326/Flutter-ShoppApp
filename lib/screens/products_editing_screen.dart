import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductEditingScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _ProductEditingScreenState createState() => _ProductEditingScreenState();
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
  final _focusNow = FocusNode();
  // used to requesto to change focus
  final _descFocus = FocusNode();
  // FocusNode need to disposed or memory leaks can happen
  final _imagecontroller = TextEditingController();
  final _imgFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  // GloablKey gives access to the Form globally, only needed in cases like this = to save values of form
  var _editedProduct = Product(
    id: '',
    price: 0,
    imageUrl: '',
    title: '',
    description: '',
  );

  @override
  void initState() {
    _imgFocus.addListener(showFocus);
    // listening to focus is on the text field or not
    // showFocus is a function I made to check focus is on the image url TextFormField or not
    // so if the focus is not on the field still the image will be previewed
    super.initState();
  }

  @override
  void dispose() {
    _imgFocus.removeListener(showFocus);
    _focusNow.dispose();
    _descFocus.dispose();
    // getting disposed of those when exiting this screen, avoiding memory leaks
    _imagecontroller.dispose();
    _imgFocus.dispose();
    super.dispose();
  }

  void showFocus() {
    if (!_imgFocus.hasFocus) {
      // to check focus is on the text form field or not, if not rebuild the page
      if ((!_imagecontroller.text.startsWith('http') &&
              !_imagecontroller.text.startsWith('https')) ||
          (!_imagecontroller.text.endsWith('.png') &&
              !_imagecontroller.text.endsWith('.jpg') &&
              !_imagecontroller.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    // triggers the validator in the textformfield
    if (!isValid) {
      return;
      // if not valid then exit this function
    }
    _form.currentState!.save();
    // notifies the text fields that save is called, no onSaved function is called in the textfields to actually save the values
    // .save is a function of Form, To call the func save() of Form outside the Widget Build we need this globalKey
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'DashBoard',
          ),
          actions: [
            IconButton(
                onPressed: _saveForm,
                // to save the form the custom built function is called
                icon: const Icon(
                  Icons.check,
                ))
          ]),
      body: Form(
        // for using a form
        key: _form,
        // connecting global key with the form
        child: ListView(
          // not unlimited fields so not .builder
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              // in TextFormField dont need to controller like in TextField cause Form handles those in the background
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'enter the title of the product',
              ),
              textInputAction: TextInputAction.next,
              // goes to next field while hit the submit button
              onFieldSubmitted: (_) {
                // when the submit button is hit do this, this function takes value as the arg but here we ignore it
                FocusScope.of(context).requestFocus(_focusNow);
                // requests to change the focus from one field to another
              },
              onSaved: (value) {
                // on saved im filling the Product class with new values
                _editedProduct = Product(
                  id: _editedProduct.id,
                  title: value.toString(),
                  // this is title field so only filling title field with new value
                  description: _editedProduct.description,
                  // title field so other values keeping them same as previous not new value
                  price: _editedProduct.price,
                  imageUrl: _editedProduct.imageUrl,
                );
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                  // returns string while error
                }
                return null;
                // returns null when valid input
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'enter the price of the product',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _focusNow,
              // to change focus to this field when submit is hit on the prev field
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(
                  _descFocus,
                );
                // to focus now to desc field
              },
              onSaved: (value) {
                // on saved im filling the Product class with new values
                _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: _editedProduct.description,
                  price: double.parse(
                    value.toString(),
                  ),
                  imageUrl: _editedProduct.imageUrl,
                );
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  // if cant parse then tryParse returns null
                  return 'enter valid price';
                }
                if (double.parse(value) <= 0) {
                  return 'enter valid price';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'enter a description about the product',
              ),
              maxLines: 3,
              // max 3 lines can be added
              keyboardType: TextInputType.multiline,
              // for long note, and this time no .next, cause we dont know when the use is done writting
              focusNode: _descFocus,
              // to change focus to this field when submit is hit on the prev field
              onSaved: (value) {
                // on saved im filling the Product class with new values
                _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: value.toString(),
                  price: _editedProduct.price,
                  imageUrl: _editedProduct.imageUrl,
                );
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter a description';
                }
                if (value.length < 10) {
                  return 'please enter atleast 10 characters';
                }
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: _imagecontroller.text.isEmpty
                      ? const Center(
                          child: Text(
                            'Image Preview',
                          ),
                        )
                      : FittedBox(
                          child: Image.network(
                            _imagecontroller.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  // cause row takes unlimited width but field cant
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'enter a Image URL of the product',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    // on submit all form fillup done
                    controller: _imagecontroller,
                    focusNode: _imgFocus,
                    onFieldSubmitted: (_) {
                      _saveForm();
                      // also submit button on the last field saves the form values
                    },
                    onSaved: (value) {
                      // on saved im filling the Product class with new values
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value.toString(),
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an image URL.';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid URL.';
                      }
                      if (!value.endsWith('.png') &&
                          !value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image URL.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
