import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qrmenu/core/extensions.dart';
import 'package:qrmenu/core/models/menu/amount.dart';
import 'package:qrmenu/core/theme/app_palette.dart';
import 'package:qrmenu/core/utils/common.dart';
import 'package:qrmenu/core/utils/constants.dart';

class AddAmountDialogComponent extends StatefulWidget {
  final double? amount;
  final double? price;
  final String? unit;

  const AddAmountDialogComponent(
      {super.key, this.amount, this.price, this.unit});

  @override
  _AddAmountDialogComponentState createState() =>
      _AddAmountDialogComponentState();
}

class _AddAmountDialogComponentState extends State<AddAmountDialogComponent> {
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    if (widget.amount != null) {
      amountController.text = widget.amount!.toString();
    }
    if (widget.price != null) {
      priceController.text = widget.price.toString();
    }
    if (widget.unit != null) {
      unitController.text = widget.unit.toString();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(16),
      width: context.width(),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Text("Add amount", style: boldTextStyle()),
            16.height,
            AppTextField(
              controller: unitController,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              decoration: inputDecoration(
                context,
                label: "Unit",
                textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
              ).copyWith(
                prefixIcon: Image.asset('assets/images/ic_Draft.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: AppPalette.bodyColor)
                    .paddingAll(12),
              ),
            ),
            16.height,
            AppTextField(
              controller: amountController,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              inputFormatters: <TextInputFormatter>[AppConstant.doubleRegExp],
              decoration: inputDecoration(
                context,
                label: "Amount",
                textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
              ).copyWith(
                prefixIcon: Image.asset('assets/images/ic_Draft.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: AppPalette.bodyColor)
                    .paddingAll(12),
              ),
            ),
            16.height,
            AppTextField(
              controller: priceController,
              textFieldType: TextFieldType.NUMBER,
              isValidationRequired: true,
              inputFormatters: <TextInputFormatter>[AppConstant.doubleRegExp],
              decoration: inputDecoration(
                context,
                label: context.localizations!.price,
                textStyle: secondaryTextStyle(color: AppPalette.bodyColor),
              ).copyWith(
                prefixIcon: Image.asset('assets/images/ic_Draft.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: AppPalette.bodyColor)
                    .paddingAll(12),
              ),
            ),
            32.height,
            Row(
              children: [
                AppButton(
                  color: context.cardColor,
                  child: Text(context.localizations!.cancel,
                      style: boldTextStyle()),
                  onTap: () {
                    hideKeyboard(context);
                    finish(context);
                  },
                ).expand(),
                8.width,
                AppButton(
                  color: AppPalette.primaryColor,
                  text: context.localizations!.add,
                  textStyle: primaryTextStyle(color: Colors.white),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (amountController.text.isNotEmpty) {
                        hideKeyboard(context);

                        Amount amount = Amount(
                            amount: double.parse(amountController.text),
                            unitPrice: double.parse(priceController.text),
                            unit: unitController.text);

                        finish(context, amount);
                      }
                    }
                  },
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
