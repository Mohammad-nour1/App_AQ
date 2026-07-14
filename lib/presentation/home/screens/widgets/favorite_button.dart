import 'package:flutter/material.dart';

IconButton favoriteButton(toggleFavorite, isFavorite) => IconButton(
  onPressed: toggleFavorite,
  icon: Icon(
    isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
    color: isFavorite ? Colors.red : null,
  ),
);
