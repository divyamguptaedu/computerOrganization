/**
 * @file hw7.c
 * @author YOUR NAME HERE
 * @collaborators NAMES OF PEOPLE THAT YOU COLLABORATED WITH HERE
 * @brief structs, pointers, pointer arithmetic, arrays, strings, and macros
 * @date 2022-03-xx
 */

// DO NOT MODIFY THE INCLUDE(S) LIST
#include <stdio.h>
#include "hw7.h"
#include "my_string.h"

// Global array of Animal structs
struct animal animals[MAX_ANIMAL_LENGTH];

int size = 0;

/** addAnimal
 *
 * @brief creates a new Animal and adds it to the array of Animal structs, "animals"
 *
 *
 * @param "species" species of the animal being created and added
 *               NOTE: if the length of the species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH. If the length
 *               is 0, return FAILURE.  
 *               
 * @param "id" id of the animal being created and added
 * @param "hungerScale" hunger scale of the animal being created and added
 * @param "habitat" habitat of the animal being created and added
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "species" length is 0 -- Done
 *         (2) "habitat" length is 0 -- Done
 *         (3) adding the new animal would cause the size of the array "animals" to
 *             exceed MAX_ANIMAL_LENGTH -- Done
 *        
 */
int addAnimal(const char *species, int id, double hungerScale, const char *habitat)
{
  size_t species_size = my_strlen(species);
  if(size + 1 > MAX_ANIMAL_LENGTH) {
    return FAILURE;
  }
  if(species_size + 1 == 0) {
    return FAILURE;
  }
  size_t habitat_size = my_strlen(habitat);
  if (habitat_size + 1 == 0) {
    return FAILURE;
  }
  if (species_size + 1 > MAX_SPECIES_LENGTH) {
   my_strncpy(animals[size].species, species, MAX_SPECIES_LENGTH - 1);
  } else {
     my_strncpy(animals[size].species, species, species_size + 1);
  }

  animals[size].id = id;
  animals[size].hungerScale = hungerScale;
  my_strncpy(animals[size].habitat, habitat, habitat_size + 1);
  size++;
  return SUCCESS;
}

/** updateAnimalSpecies
 *
 * @brief updates the species of an existing animal in the array of Animal structs, "animals"
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @param "species" new species of Animal "animal"
 *               NOTE: if the length of species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals" based on its id
 */
int updateAnimalSpecies(struct animal animal, const char *species)
{
  size_t new_species_name = my_strlen(species) + 1;
  if (new_species_name >= MAX_SPECIES_LENGTH) {
    new_species_name = MAX_SPECIES_LENGTH - 1;
  }
  for (int i = 0; i < size; ++i) {
    if (animals[i].id == animal.id) {
      my_strncpy(animals[i].species, species, new_species_name);
      *(animals[i].species + new_species_name) = 0;
      return SUCCESS;
    }
  }
  return FAILURE;
}

/** averageHungerScale
* @brief Search for all animals with the same species and find average the hungerScales
* 
* @param "species" Species that you want to find the average hungerScale for
* @return the average hungerScale of the specified species
*         if the species does not exist, return 0.0
*/
double averageHungerScale(const char *species)
{
  double hunger_sum = 0.0;
  int new_size = 0;
  for (int i = 0; i < size; i++) {
    if (my_strncmp(animals[i].species, species, my_strlen(species)) == 0) {
      hunger_sum = hunger_sum + animals[i].hungerScale;
      new_size++;
    }
  }
  if (hunger_sum == 0.0) {
    return 0.0;
  }
  return hunger_sum/new_size;
}

/** swapAnimals
 *
 * @brief swaps the position of two Animal structs in the array of Animal structs, "animals"
 *
 * @param "index1" index of the first Animal struct in the array "animals"
 * @param "index2" index of the second Animal struct in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "index1" and/or "index2" are negative numbers
 *         (2) "index1" and/or "index2" are out of bounds of the array "animals"
 */
int swapAnimals(int index1, int index2)
{
  if(index1 < 0 || index2 < 0 || index1 > size - 1 || index2 > size - 1) {
    return FAILURE;
  }
  struct animal temp = animals[index1];
  animals[index1] = animals[index2];
  animals[index2] = temp;
  return SUCCESS;
}

/** compareHabitat
 *
 * @brief compares the two Animals animals' habitats (using ASCII)
 *
 * @param "animal1" Animal struct that exists in the array "animals"
 * @param "animal2" Animal struct that exists in the array "animals"
 * @return negative number if animal1 is less than animal2, positive number if animal1 is greater
 *         than animal2, and 0 if animal1 is equal to animal2
 */
int compareHabitat(struct animal animal1, struct animal animal2)
{
  size_t one = 0;
  size_t two = 0;
  for(int i = 0; i < size; i++) {
    if(my_strncmp(animals[i].species, animal1.species, my_strlen(animal1.species)) == 0) {
      one = i;
    }
    if(my_strncmp(animals[i].species, animal2.species, my_strlen(animal2.species)) == 0) {
      two = i;
    }
  }
  if(my_strncmp(animals[one].habitat, animals[two].habitat, my_strlen(animals[two].habitat)) > 0) {
      return 1;
    } else if(my_strncmp(animals[one].habitat, animals[two].habitat, my_strlen(animals[two].habitat)) < 0) {
      return -1;
    } else {
      return 0;
    }
return SUCCESS;
}

/** removeAnimal
 *
 * @brief removes Animal in the array of Animal structs, "animals", that has the same species
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals"
 */
int removeAnimal(struct animal animal)
{
  int found = 0;
  for (int i = 0; i < size; i++) {
    if (my_strncmp(animals[i].species, animal.species, my_strlen(animals[i].species)) == 0) {
      for (int j = i; j < size - 1; j++) {
        swapAnimals(j, j + 1);
      }
      found = 1;
      size--;
    }
  }
  if(found == 0) {
    return FAILURE;
  }
  return SUCCESS;
}

/** sortAnimal
 *
 * @brief using the compareHabitat function, sort the Animals in the array of
 * Animal structs, "animals," by the animals' habitat
 * If two animals have the same habitat, place the hungier animal first
 *
 * @param void
 * @return void
 */
void sortAnimalsByHabitat(void)
{
  for(int i = 0; i < size - 1; i++) {
    for(int j = 0; j < (size-i-1); j++) {
      if(compareHabitat(animals[j], animals[j + 1]) > 0) {
        swapAnimals(j, j + 1);
      }
      if(compareHabitat(animals[j], animals[j + 1]) == 0) {
        if(animals[j].hungerScale < animals[j + 1].hungerScale) {
          swapAnimals(j, j + 1);
        }
      }
    }
  }
}
