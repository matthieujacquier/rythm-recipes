class Match < ApplicationRecord
  belongs_to :user
  belongs_to :music_suggestion
  has_one :recipe
  after_create :create_recipe_from_seed

  private

  def create_recipe_from_seed
    Recipe.create!(
      name: "Shrimp Scampi Meets Salsa Verde",
      difficulty: 4,
      food_type: "Seafood",
      image_url: "https://www.seriouseats.com/thmb/KBA0gsAMS9QfDYi2oN1emoH1G1Q=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/20250605-SEA-mexicanshrimppasta-shrirepp-HERO-490f38add46f47a997d747e290b6ac9b.jpg",
      ingredients: "1 pound (454 g) jumbo shell-on shrimp, peeled and deveined, shells reserved\n 1 teaspoon kosher salt, plus more to taste\n 1/4 teaspoon baking soda\n 8 tablespoons (114 g) unsalted butter\n 10 medium cloves garlic (50 g)\n 5 serrano chiles (50 g), stemmed, deveined, and seeded if desired\n 1 pound dried linguine or fettuccine\n 2 teaspoons grated lime zest plus 2 tablespoons (30 ml) lime juice from 1 whole lime, divided\n 1 loosely packed cup fresh cilantro leaves, minced",
      portion_size: 4,
      instructions: "Cut shrimp in half crosswise. In a large bowl, toss shrimp with 1 teaspoon kosher salt and baking soda. Refrigerate for 15 minutes or up to 1 hour.\n Meanwhile, in a large skillet, add butter and reserved shrimp shells and heat over medium-low heat. Cook, stirring occasionally, until butter is melted and bubbling and shells are bright orange, 7 to 10 minutes. In a fine-mesh strainer set over a bowl, strain butter with shells. Discard shells and return shrimp-infused butter to skillet.\n In a mortar and pestle, smash serranos and garlic into a rough paste; alternatively, finely mince by hand. Set aside.\n In a large pot of salted boiling water, cook pasta, stirring frequently for first 30 seconds to prevent sticking, until pasta is just shy of al dente (about 2 minutes less than package directions). Drain pasta, reserving 2 cupscooking water.\n Return skillet with butter to medium heat. Add shrimp and cook, stirring occasionally, until cooked through, about 2 minutes. Using tongs, transfer shrimp to a bowl or plate. Reduce heat to medium-low and add crushed serranos and garlic. Cook, stirring frequently, until mixture softens and is aromatic, 3 to 5 minutes.\n Remove pan from heat. Stir in lime juice. Add pasta and 1 1/2 cups reserved cooking water, set over high heat, and cook, stirring and tossing rapidly, until pasta is al dente and sauce is slightly thickened and noodles are glossy, 2 to 3 minutes. Add additional pasta water, a few tablespoons at a time, if needed, to evenly coat the pasta.\n Add cooked shrimp, lime zest, and cilantro and toss to combine. Season with salt to taste.\n Serve immediately.",
      cuisine: "Mexican",
      duration: rand(60..180),
      description: "This shrimp pasta with cilantro and lime is spicy, citrusy, and bold.",
      match: self
    )

    Recipe.create!(
      name: "Pasta chi Vruoccoli Arriminati",
      difficulty: 4,
      food_type: "Seafood",
      image_url: "https://www.seriouseats.com/thmb/fs3Aix8Phtod4wz7tEJaO5PeJ2g=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2021__03__20210310-Vruoccoli-Arriminati-sasha-marx-13-1-5fa897847b15488b80f54a8a3b927d05.jpg",
      ingredients: "225 g bread, cut into 3/4- to 1-inch pieces\n 2 tablespoons (30 ml) extra-virgin olive oil\n Kosher salt\n 1 tablespoon (15 ml) water\n 1/4 teaspoon saffron threads\n 1 small head cauliflower, cut into 1- to 2-inch florets (680 to 800 g)\n 1/4 cup (60 ml) plus 1 tablespoon (15 ml) extra-virgin olive oil\n 1 small yellow onion, finely chopped (115 g)\n 5 anchovy fillets (15 g)\n 1/4 cup (25 g) golden raisins\n 1/4 cup (20 g) pine nuts, lightly toasted\n Pinch fennel pollen (optional)\n 12 ounces (340 g) short, tubular dried pasta such as sedani or rigatoni, or long pasta such as bucatini\n 1/2 cup toasted breadcrumbs (50 g), divided",
      portion_size: 4,
      instructions: "For the Toasted Breadcrumbs: If using fresh or lightly stale bread, adjust oven rack to middle position and preheat oven to 325°F (165°C). (If using fully stale and dried bread, skip baking step.) Arrange bread in single layer on rimmed baking sheet and bake until completely dried, 20 to 30 minutes. Remove from oven and allow to cool to room temperature, about 10 minutes.\n Transfer bread to food processor bowl (set aside but don't clean rimmed baking sheet), and pulse until reduced to small crumbs, taking care not to over-process into a fine powder, 8 to 10 pulses. Combine breadcrumbs and 2 tablespoons (30ml) oil in a large, deep skillet and cook over medium-low heat, stirring and tossing occasionally, until crisp and golden brown, 8 to 10 minutes. Season lightly with salt.\n Transfer toasted breadcrumbs to reserved rimmed baking sheet, spread into an even layer, and set aside to cool to room temperature; wipe out skillet. Once cool, set aside 1/2 cup (50g) toasted breadcrumbs for the pasta, and transfer remaining crumbs to an airtight container for future use; the extra breadcrumbs can be stored at room temperature for up to 2 weeks.\n For the Pasta: Bring a pot of salted water to a boil over high heat. While water comes to a boil, stir together 1 tablespoon (15ml) water and saffron in a small bowl; set aside.\n Add cauliflower and cook at a rapid simmer, stirring occasionally, until floret pieces are just tender and offer very little resistance when poked with a paring knife at thickest part of stem end, about 6 minutes. Using a spider skimmer, fine-mesh strainer, or slotted spoon, drain cauliflower while keeping boiling water in the pot; transfer cauliflower to a bowl or plate and set aside.\n Meanwhile, heat 1/4 cup (60ml) oil in now-empty skillet over medium heat until shimmering. Add onion, season lightly with salt, and cook, stirring frequently, until softened but not browned, 2 to 4 minutes.\n Add anchovies and cook, stirring and breaking up anchovies occasionally with a wooden spoon, until anchovies have dissolved, about 2 minutes.\n Add cauliflower to skillet along with 1/2 cup (120ml) reserved cooking water, raisins, pine nuts, fennel pollen (if using), and saffron water. Cook over medium, stirring often and breaking up cauliflower into small pieces with a wooden spoon, until raisins soften and plump and cooking water reduces and glazes cauliflower, 4 to 6 minutes.\n Meanwhile, cook pasta in the reserved pot of boiling water used for cooking the cauliflower until pasta is just shy of al dente (about 2 minutes less than the package directs). Using a spider skimmer (or tongs if cooking bucatini), transfer pasta to cauliflower mixer in skillet , along with 1/2 cup (118ml) pasta cooking water. Alternatively, drain pasta using a colander or fine-mesh strainer, making sure to reserve at least 1 cup (237ml) pasta cooking water.\n Increase heat to high and cook, stirring and tossing rapidly, until pasta is al dente and a creamy looking sauce forms and clings to pasta, about 2 minutes. Stir in remaining 1 tablespoon (15ml) oil and toss to coat, adding more pasta cooking water in 1/4-cup (60ml) increments as needed to achieve desired consistency.\n Remove from heat, add half of the breadcrumbs (1/4 cup; 30g), and toss to combine. Pasta should be well-coated but not swimming in sauce (the sauce will continue to tighten up in the time it takes to plate and serve). Adjust sauce consistency as needed with more pasta water if it seems too dry.\n Divide pasta between individual serving bowls, sprinkle with breadcrumbs, and serve right away.",
      cuisine: "Italian",
      duration: rand(60..180),
      description: "Cauliflower cooked down into a savory-sweet sauce with Sicilian staples: anchovies, pine nuts, raisins, saffron, and toasted breadcrumbs.",
      match: self
    )

    Recipe.create!(
      name: "Avocado Toast With Mango, Chili Powder, and Mint",
      difficulty: 2,
      food_type: "Vegetarian",
      image_url: "https://www.seriouseats.com/thmb/guC2MlIvwvfEh-X5QOw5JPd-3GI=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__recipes__images__2016__05__20160502-avocado-toast-vicky-wasik-mango-12-baa3f3b9eed640d98542557076584b87.jpg",
      ingredients: "4 slices country or sandwich bread, approximately 1/2 inch thick\n Extra-virgin olive oil\n 2 medium pitted and peeled avocado\n 24 1/4-inch-thick slices mango from 2 large mangos, or enough to cover surface of bread\n Freshly squeezed lemon juice to taste, from 1 medium sized lemon\n Ancho chile powder\n Freshly chopped mint leaves, for garnish\n Flaky sea salt",
      portion_size: 4,
      instructions: "Lightly brush bread with olive oil and toast to desired level of doneness.\n Top with avocado and mash with a fork to cover entire surface.\n Add single layer of mango, sprinkle with a squeeze of lemon juice, and dust with a dash of chili powder.\n Garnish with mint and salt. Serve.",
      cuisine: "World",
      duration: rand(60..180),
      description: "Juicy, tart mangoes are surprisingly excellent at cutting through the richness of the avocado in this open-faced sandwich.",
      match: self
    )

    Recipe.create!(
      name: "Pasta ai Funghi",
      difficulty: 4,
      food_type: "Meat",
      image_url: "https://www.seriouseats.com/thmb/sliq7_6kyoToe1i5Lzmd1xxcIRs=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2021__02__20210204-funghi-pasta-vicky-wasik-17-55074a9a66864d14afecf8cbd4445597.jpg",
      ingredients: "1 cup (240 ml) homemade or store-bought low-sodium chicken stock\n 1 1/2 teaspoons (4 g) powdered gelatin\n 2 tablespoons (30 ml) extra-virgin olive oil\n 675 g mixed mushrooms (such as shiitake, oyster, cremini, etc.), cleaned, trimmed, and thinly sliced or torn by hand\n Kosher salt and freshly ground black pepper\n 3 medium shallots, finely minced (about 120 g)\n 2 medium (10 g) garlic cloves, minced\n 2 tablespoons (4 g) chopped fresh thyme leaves\n 120 ml dry white wine or 60 ml dry sherry\n 1 teaspoon (5 ml) fish sauce (optional)\n 1 pound (450 g) short dried pasta (such as casarecce or gemelli) or long fresh egg-dough pasta (such as tagliatelle or fettuccine)\n 6 tablespoons unsalted butter (85 g)\n 85g grated Parmigiano-Reggiano\n 10 g chopped fresh flat-leaf parsley leaves",
      portion_size: 4,
      instructions: "Pour stock into a small bowl or liquid measuring cup and evenly sprinkle gelatin over surface of stock. Set aside.\n In a large 12-inch cast iron or stainless steel skillet, heat oil over medium-high heat until shimmering. Add mushrooms, season with salt and pepper, and cook, stirring frequently with a wooden spoon, until moisture has evaporated and mushrooms are deeply browned, 12 to 15 minutes.\n Add shallots, garlic, and thyme and cook, stirring constantly, until fragrant and shallots are softened, 30 seconds to 1 minute.\n Add wine or sherry, and cook, swirling pan and scraping up any stuck-on bits with a wooden spoon, until wine is reduced by half, about 30 seconds.\n Add chicken stock mixture, season lightly with salt, and bring to a simmer. Reduce heat to medium-low, add fish sauce (if using), and cook, stirring occasionally, until mushroom mixture is thickened to a saucy consistency, about 5 minutes. Turn off heat.\n Meanwhile, in a pot of salted boiling water, cook pasta. If using dry pasta, cook until just shy of al dente (1 to 2 minutes less than the package directs). If using fresh pasta, cook until noodles are barely cooked through. Using either a spider skimmer (for short pasta) or tongs (for long fresh pasta), transfer pasta to pan with mushrooms along with 3/4 cup (180ml) pasta cooking water. Alternatively, drain pasta using a colander or fine-mesh strainer, making sure to reserve at least 2 cups (475ml) pasta cooking water.\n Heat sauce and pasta over high and cook, stirring and tossing rapidly, until pasta is al dente (fresh pasta will never be truly al dente) and sauce is thickened and coats noodles, 1 to 2 minutes, adding more pasta cooking water in 1/4 cup (60ml) increments as needed.\n At this point, the sauce should coat the pasta but still be loose enough to pool around the edges of the pan. Add butter, and stir and toss rapidly to melt and emulsify into the sauce.\n Remove from heat, add 3/4 of grated cheese and all of the parsley, and stir rapidly to incorporate.\n Season with salt to taste. Serve immediately, passing remaining grated cheese at the table.",
      cuisine: "World",
      duration: rand(60..180),
      description: "Shallots, garlic, white wine, and Parmesan bring out the earthy flavors of mushrooms in this comforting all-weather pasta.",
      match: self
    )

    Recipe.create!(
      name: "Garlic Fried Rice Recipe",
      difficulty: 1,
      food_type: "Vegetarian",
      image_url: "https://www.seriouseats.com/thmb/EPuXhVvp0P9fgWQDzvAKi6uHJEM=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2019__10__20191023-chicken-adobo-vicky-wasik-22-80a92e45ce4941e4b114e28882aadadb.jpg",
      ingredients: "75ml plus 1 tablespoon canola oil or other neutral oil\n 8 garlic cloves, crushed and sliced thinly\n 700g cooked white rice, preferably long-grain, but any variety will do",
      portion_size: 4,
      instructions: "In a small saucepan, heat oil over medium heat until shimmering.\n Add garlic and cook, stirring constantly, until garlic softens, becomes very aromatic, and turns lightly golden, 30 seconds to 1 minute. Strain oil through a fine-mesh strainer directly into a wok; reserve cooked garlic and set aside.\n Heat wok over high heat until oil is shimmering. Add rice, breaking up larger clumps with a spatula and tossing to coat with garlic-flavored oil.\n Cook, stirring and tossing frequently, until no clumps of rice remain and rice is warmed through, about 4 minutes.\n Add reserved garlic to rice and toss to combine. Serve immediately.",
      cuisine: "World",
      duration: rand(60..180),
      description: "A perfect accompaniment to chicken adobo, or any other super-savory, super-saucy food.",
      match: self
    )
  end
end
