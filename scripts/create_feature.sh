#!/bin/bash
# save as: create_feature.sh

FEATURE_NAME=$1

# Create feature folder structure
mkdir -p lib/features/$FEATURE_NAME/{data,domain,presentation,di}
mkdir -p lib/features/$FEATURE_NAME/data/{datasources,models,repositories}
mkdir -p lib/features/$FEATURE_NAME/domain/{entities,repositories,usecases}
mkdir -p lib/features/$FEATURE_NAME/presentation/{bloc,pages,widgets}

# Create placeholder files
touch lib/features/$FEATURE_NAME/data/datasources/${FEATURE_NAME}_datasource.dart
touch lib/features/$FEATURE_NAME/data/models/${FEATURE_NAME}_model.dart
touch lib/features/$FEATURE_NAME/data/repositories/${FEATURE_NAME}_repository_impl.dart
touch lib/features/$FEATURE_NAME/domain/entities/${FEATURE_NAME}.dart
touch lib/features/$FEATURE_NAME/domain/repositories/${FEATURE_NAME}_repository.dart
touch lib/features/$FEATURE_NAME/domain/usecases/${FEATURE_NAME}_usecase.dart
touch lib/features/$FEATURE_NAME/presentation/bloc/${FEATURE_NAME}_bloc.dart
touch lib/features/$FEATURE_NAME/presentation/pages/${FEATURE_NAME}_page.dart
touch lib/features/$FEATURE_NAME/di/${FEATURE_NAME}_injection.dart

echo "Feature $FEATURE_NAME created successfully!"