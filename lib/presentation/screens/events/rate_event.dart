import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/controllers/providers/rating_provider.dart';
import 'package:hopaut/presentation/widgets/buttons/persist_button.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';
import 'package:hopaut/presentation/widgets/inputs/text_area_input.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class RateEvent extends StatefulWidget {
  final int postId;

  RateEvent({required this.postId});

  @override
  _RateEventState createState() => _RateEventState();
}

class _RateEventState extends State<RateEvent> {
  TextEditingController ratingController = TextEditingController();
  RatingProvider provider = getIt<RatingProvider>();

  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<RatingProvider>(context, listen: true);
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Application.router.pop(context),
          ),
          title: Text(LocaleKeys.Event_Rating_pageTitle.tr()),
          flexibleSpace: Container(
            decoration: decorationGradient(),
          ),
        ),
        body: Builder(builder: (context) => _ratingForm(provider, context)));
  }

  Widget _ratingForm(RatingProvider provider, BuildContext context) {
    if (provider.ratingFormStatus is Failed) {
      // Translation
      Failed formStatus = provider.ratingFormStatus as Failed;
      Future.delayed(Duration.zero, () async {
        showSnackBarWithError(
            context: context, message: formStatus.errorMessage!);
      });
      provider.ratingFormStatus = new Idle();
    }
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                StarRating(
                  onChanged: (index) => provider.onRatingChanged(index),
                  value: provider.rating,
                ),
                textAreaInput(
                  isStateValid:
                      provider.validateFeedback(ratingController.text),
                  onChange: (v) =>
                      provider.onRatingMessageChange(v, ratingController),
                  validationMessage: LocaleKeys.Event_Rating_validation.tr(),
                ),
                SizedBox(height: 12),
                persistButton(
                    label: LocaleKeys.Event_Rating_button,
                    context: context,
                    isStateValid:
                        provider.validateFeedback(ratingController.text) &&
                            provider.rating > 0,
                    onPressed: () async => {
                          if (_formKey.currentState!.validate())
                            {
                              await provider.rateUserAsync(
                                  ratingController.text,
                                  widget.postId,
                                  context),
                            }
                        })
                // ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: provider.ratingFormStatus is Submitted,
          child: Center(
            child: overlayBlurBackgroundCircularProgressIndicator(
                context, LocaleKeys.Event_Rating_dialog.tr()),
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final void Function(int index)? onChanged;
  final int? value;
  final IconData? filledStar;
  final IconData? unfilledStar;

  const StarRating({
    Key? key,
    this.onChanged,
    this.value = 0,
    this.filledStar,
    this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = HATheme.HOPAUT_ORANGE;
    final size = 30.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: onChanged != null
              ? () {
                  onChanged!(value == index + 1 ? index : index + 1);
                }
              : null,
          color: index < value! ? color : null,
          iconSize: size,
          icon: Icon(
            index < value!
                ? filledStar ?? Icons.star
                : unfilledStar ?? Icons.star_border,
          ),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1}" + LocaleKeys.Event_Rating_outOf.tr(),
        );
      }),
    );
  }
}
