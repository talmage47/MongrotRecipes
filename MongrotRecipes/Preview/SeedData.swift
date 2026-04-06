import CoreData

/// Populates a managed object context with realistic sample data for previews and development.
enum SeedData {

    static func populate(in context: NSManagedObjectContext) {
        // MARK: Groups

        let breakfast = makeGroup(title: "Breakfast", subtitle: "Morning staples", sortOrder: 0, isPinned: false, context: context)
        let dessert   = makeGroup(title: "Dessert",   subtitle: "Sweet treats",    sortOrder: 1, isPinned: false, context: context)
        let grill     = makeGroup(title: "Grill",     subtitle: "Fire & smoke",    sortOrder: 2, isPinned: false, context: context)
        let mealPrep  = makeGroup(title: "Meal Prep", subtitle: "Cook once, eat all week", sortOrder: 3, isPinned: false, context: context)
        let family    = makeGroup(title: "Family Favorites", subtitle: "Crowd pleasers", sortOrder: 4, isPinned: true, context: context)

        // MARK: Recipes

        // 1 — Buttermilk Pancakes
        let pancakes = makeRecipe(
            title: "Buttermilk Pancakes",
            summary: "Fluffy, golden-edged pancakes with a slight tang.",
            servings: 4,
            prep: 10,
            cook: 20,
            context: context
        )
        addIngredients(to: pancakes, items: [
            ("1½", "cups", "all-purpose flour", nil),
            ("2",  "tbsp", "sugar", nil),
            ("1",  "tsp",  "baking powder", nil),
            ("½",  "tsp",  "baking soda", nil),
            ("¼",  "tsp",  "salt", nil),
            ("1¼", "cups", "buttermilk", nil),
            ("1",  "",     "large egg", nil),
            ("2",  "tbsp", "unsalted butter", "melted, plus more for pan"),
        ], context: context)
        addSteps(to: pancakes, steps: [
            "Whisk together flour, sugar, baking powder, baking soda, and salt in a large bowl.",
            "In a separate bowl, whisk buttermilk, egg, and melted butter until combined.",
            "Pour the wet ingredients into the dry and stir until just combined — lumps are fine.",
            "Heat a lightly buttered skillet over medium heat. Pour ¼-cup portions of batter.",
            "Cook until bubbles form on the surface and edges look set, about 2 min. Flip and cook 1 min more.",
            "Serve immediately with maple syrup.",
        ], context: context)
        pancakes.addToGroups(breakfast)

        // 2 — Avocado Toast with Poached Eggs
        let avocadoToast = makeRecipe(
            title: "Avocado Toast with Poached Eggs",
            summary: "Creamy avocado on crusty sourdough topped with a perfectly poached egg.",
            servings: 2,
            prep: 5,
            cook: 10,
            context: context
        )
        avocadoToast.isPinned = true
        addIngredients(to: avocadoToast, items: [
            ("2",  "slices", "sourdough bread", "thickly cut"),
            ("1",  "",       "ripe avocado", nil),
            ("2",  "",       "large eggs", nil),
            ("1",  "tbsp",   "white vinegar", "for poaching"),
            ("",   "",       "flaky sea salt", "to taste"),
            ("",   "",       "red pepper flakes", "optional"),
            ("½",  "",       "lemon", "juice of"),
        ], context: context)
        addSteps(to: avocadoToast, steps: [
            "Toast the sourdough until golden and crisp.",
            "Mash the avocado with lemon juice and a pinch of salt.",
            "Bring a small saucepan of water to a gentle simmer. Add vinegar.",
            "Crack an egg into a small cup. Create a gentle vortex and slide the egg in. Cook 3 min.",
            "Spread avocado on toast, top with the poached egg.",
            "Season with flaky salt and red pepper flakes.",
        ], context: context)
        avocadoToast.addToGroups(breakfast)

        // 3 — Classic Chocolate Chip Cookies
        let cookies = makeRecipe(
            title: "Classic Chocolate Chip Cookies",
            summary: "Crisp edges, chewy centers, and pools of melted chocolate.",
            servings: 24,
            prep: 15,
            cook: 12,
            context: context
        )
        cookies.calories  = 180
        cookies.protein   = 2
        cookies.carbs     = 25
        cookies.fat       = 9
        addIngredients(to: cookies, items: [
            ("2¼", "cups", "all-purpose flour", nil),
            ("1",  "tsp",  "baking soda", nil),
            ("1",  "tsp",  "salt", nil),
            ("1",  "cup",  "unsalted butter", "room temperature"),
            ("¾",  "cup",  "granulated sugar", nil),
            ("¾",  "cup",  "packed brown sugar", nil),
            ("2",  "",     "large eggs", nil),
            ("2",  "tsp",  "vanilla extract", nil),
            ("2",  "cups", "chocolate chips", nil),
        ], context: context)
        addSteps(to: cookies, steps: [
            "Preheat oven to 375°F (190°C). Line baking sheets with parchment.",
            "Whisk flour, baking soda, and salt in a bowl.",
            "Beat butter and both sugars until light and fluffy, about 3 min.",
            "Beat in eggs and vanilla.",
            "Gradually mix in the flour mixture, then stir in chocolate chips.",
            "Drop rounded tablespoons onto prepared pans, spacing 2 inches apart.",
            "Bake 9–11 min until golden brown. Cool on pan 2 min, then transfer.",
        ], context: context)
        cookies.addToGroups(dessert)

        // 4 — Grilled Ribeye Steak
        let ribeye = makeRecipe(
            title: "Grilled Ribeye Steak",
            summary: "Bold crust, juicy center. The only steak recipe you need.",
            servings: 2,
            prep: 5,
            cook: 12,
            context: context
        )
        ribeye.calories = 620
        ribeye.protein  = 48
        ribeye.fat      = 46
        ribeye.carbs    = 0
        addIngredients(to: ribeye, items: [
            ("2",  "",     "ribeye steaks", "1¼ inch thick, ~12 oz each"),
            ("2",  "tsp",  "kosher salt", nil),
            ("1",  "tsp",  "black pepper", "coarsely ground"),
            ("1",  "tbsp", "vegetable oil", nil),
            ("2",  "tbsp", "unsalted butter", nil),
            ("2",  "cloves","garlic", "crushed"),
            ("2",  "sprigs","fresh thyme", nil),
        ], context: context)
        addSteps(to: ribeye, steps: [
            "Pat steaks dry with paper towels. Season all sides generously with salt and pepper.",
            "Let steaks rest at room temperature for 30 min.",
            "Heat a cast-iron skillet or grill to high. Add oil.",
            "Sear steaks 3–4 min per side for medium-rare (130°F internal).",
            "Add butter, garlic, and thyme. Baste the steaks for 1 min.",
            "Rest 5 min before slicing. Slice against the grain.",
        ], context: context)
        ribeye.addToGroups(grill)
        ribeye.addToGroups(family)

        // 5 — BBQ Chicken Thighs
        let bbqChicken = makeRecipe(
            title: "BBQ Chicken Thighs",
            summary: "Smoky, sticky, fall-off-the-bone grilled chicken thighs.",
            servings: 6,
            prep: 15,
            cook: 35,
            context: context
        )
        bbqChicken.isPinned = true
        addIngredients(to: bbqChicken, items: [
            ("6",  "",     "bone-in chicken thighs", "skin-on"),
            ("1",  "cup",  "BBQ sauce", "your favorite brand"),
            ("1",  "tbsp", "smoked paprika", nil),
            ("1",  "tsp",  "garlic powder", nil),
            ("1",  "tsp",  "onion powder", nil),
            ("1",  "tsp",  "kosher salt", nil),
            ("½",  "tsp",  "black pepper", nil),
            ("1",  "tbsp", "olive oil", nil),
        ], context: context)
        addSteps(to: bbqChicken, steps: [
            "Mix paprika, garlic powder, onion powder, salt, and pepper to make a dry rub.",
            "Pat chicken dry and rub all over with olive oil, then the dry rub.",
            "Preheat grill to medium heat (350–400°F). Oil the grates.",
            "Grill chicken skin-side down 8–10 min until skin is crisp.",
            "Flip, brush with BBQ sauce, and grill 15 min more, basting frequently.",
            "Chicken is done when internal temp reaches 165°F. Rest 5 min before serving.",
        ], context: context)
        bbqChicken.addToGroups(grill)
        bbqChicken.addToGroups(family)

        // 6 — Overnight Oats
        let overnightOats = makeRecipe(
            title: "Overnight Oats",
            summary: "Zero-effort breakfast. Mix tonight, eat tomorrow.",
            servings: 1,
            prep: 5,
            cook: 0,
            context: context
        )
        overnightOats.calories = 380
        overnightOats.protein  = 14
        overnightOats.carbs    = 52
        overnightOats.fat      = 12
        addIngredients(to: overnightOats, items: [
            ("½",  "cup",  "rolled oats", nil),
            ("½",  "cup",  "milk", "or oat milk"),
            ("¼",  "cup",  "Greek yogurt", nil),
            ("1",  "tbsp", "chia seeds", nil),
            ("1",  "tbsp", "maple syrup", nil),
            ("½",  "tsp",  "vanilla extract", nil),
            ("",   "",     "fresh berries", "to top"),
        ], context: context)
        addSteps(to: overnightOats, steps: [
            "Combine oats, milk, yogurt, chia seeds, maple syrup, and vanilla in a jar or container.",
            "Stir well and cover tightly.",
            "Refrigerate overnight or at least 4 hours.",
            "In the morning, stir and top with fresh berries. Add more milk if too thick.",
        ], context: context)
        overnightOats.addToGroups(breakfast)
        overnightOats.addToGroups(mealPrep)

        // 7 — Banana Bread
        let bananaBread = makeRecipe(
            title: "Banana Bread",
            summary: "Deeply moist, warmly spiced loaf. Best on day two.",
            servings: 10,
            prep: 10,
            cook: 65,
            context: context
        )
        addIngredients(to: bananaBread, items: [
            ("3",  "",     "very ripe bananas", "mashed"),
            ("⅓",  "cup",  "unsalted butter", "melted"),
            ("¾",  "cup",  "sugar", nil),
            ("1",  "",     "large egg", "beaten"),
            ("1",  "tsp",  "vanilla extract", nil),
            ("1",  "tsp",  "baking soda", nil),
            ("¼",  "tsp",  "salt", nil),
            ("1",  "cup",  "all-purpose flour", nil),
            ("½",  "tsp",  "cinnamon", nil),
        ], context: context)
        addSteps(to: bananaBread, steps: [
            "Preheat oven to 350°F (175°C). Grease a 4×8 inch loaf pan.",
            "Mix melted butter into the mashed bananas.",
            "Stir in sugar, egg, and vanilla.",
            "Add baking soda, salt, and cinnamon. Mix well.",
            "Fold in the flour until just combined — do not overmix.",
            "Pour into pan and bake 55–65 min until a toothpick comes out clean.",
            "Cool in pan 10 min, then turn out and cool completely.",
        ], context: context)
        bananaBread.addToGroups(dessert)

        // 8 — Grandma's Lasagna
        let lasagna = makeRecipe(
            title: "Grandma's Lasagna",
            summary: "Layers of rich meat sauce, creamy béchamel, and three cheeses.",
            servings: 8,
            prep: 30,
            cook: 60,
            context: context
        )
        lasagna.isPinned  = true
        lasagna.isFavorite = true
        addIngredients(to: lasagna, items: [
            ("12", "sheets", "lasagna noodles", "cooked al dente"),
            ("1",  "lb",    "ground beef", nil),
            ("½",  "lb",    "Italian sausage", "removed from casing"),
            ("1",  "jar",   "marinara sauce", "about 24 oz"),
            ("1",  "can",   "crushed tomatoes", "28 oz"),
            ("15", "oz",    "ricotta cheese", nil),
            ("1",  "",      "large egg", nil),
            ("2",  "cups",  "shredded mozzarella", nil),
            ("½",  "cup",   "grated Parmesan", nil),
            ("2",  "cloves","garlic", "minced"),
            ("1",  "tsp",   "dried oregano", nil),
            ("",   "",      "fresh basil", "to finish"),
        ], context: context)
        addSteps(to: lasagna, steps: [
            "Preheat oven to 375°F (190°C).",
            "Brown beef and sausage in a large skillet over medium-high heat. Drain fat.",
            "Add garlic and cook 1 min. Stir in marinara, crushed tomatoes, and oregano. Simmer 15 min.",
            "Mix ricotta with egg and a pinch of salt.",
            "Spread a thin layer of meat sauce in a 9×13 dish.",
            "Layer: noodles → ricotta → meat sauce → mozzarella. Repeat 3 times.",
            "Finish with noodles, remaining sauce, and mozzarella. Top with Parmesan.",
            "Cover with foil and bake 45 min. Uncover and bake 15 min more until bubbly.",
            "Rest 15 min before slicing. Garnish with fresh basil.",
        ], context: context)
        lasagna.addToGroups(family)

        // MARK: Save
        do {
            try context.save()
        } catch {
            print("SeedData save failed: \(error)")
        }
    }

    // MARK: - Helpers

    @discardableResult
    private static func makeGroup(
        title: String,
        subtitle: String?,
        sortOrder: Int,
        isPinned: Bool,
        context: NSManagedObjectContext
    ) -> CollectionGroup {
        let group = CollectionGroup(context: context)
        group.id        = UUID()
        group.title     = title
        group.subtitle  = subtitle
        group.sortOrder = NSNumber(value: sortOrder)
        group.isPinned  = NSNumber(value: isPinned)
        group.createdAt = Date()
        group.updatedAt = Date()
        return group
    }

    @discardableResult
    private static func makeRecipe(
        title: String,
        summary: String,
        servings: Int,
        prep: Int,
        cook: Int,
        context: NSManagedObjectContext
    ) -> Recipe {
        let recipe = Recipe(context: context)
        recipe.id              = UUID()
        recipe.title           = title
        recipe.summary         = summary
        recipe.servings        = NSNumber(value: servings)
        recipe.prepTimeMinutes = NSNumber(value: prep)
        recipe.cookTimeMinutes = NSNumber(value: cook)
        recipe.isFavorite      = false
        recipe.isPinned        = false
        recipe.createdAt       = Date()
        recipe.updatedAt       = Date()
        return recipe
    }

    private static func addIngredients(
        to recipe: Recipe,
        items: [(String, String, String, String?)],
        context: NSManagedObjectContext
    ) {
        for (index, item) in items.enumerated() {
            let (amount, unit, name, notes) = item
            let ingredient = Ingredient(context: context)
            ingredient.id         = UUID()
            ingredient.name       = name
            ingredient.unit       = unit.isEmpty ? nil : unit
            ingredient.notes      = notes
            ingredient.sortOrder  = NSNumber(value: index)
            // Parse the display string into a numeric value for scaling.
            ingredient.baseAmount = NSNumber(value: parseAmount(amount))
            ingredient.amount     = ingredient.baseAmount
            ingredient.recipe     = recipe
        }
    }

    private static func addSteps(
        to recipe: Recipe,
        steps: [String],
        context: NSManagedObjectContext
    ) {
        for (index, text) in steps.enumerated() {
            let step = InstructionStep(context: context)
            step.id        = UUID()
            step.text      = text
            step.sortOrder = NSNumber(value: index)
            step.recipe    = recipe
        }
    }

    /// Converts common fraction strings like "1½", "¾", "2¼" to Double.
    private static func parseAmount(_ raw: String) -> Double {
        let fractionMap: [Character: Double] = [
            "½": 0.5, "⅓": 0.333, "⅔": 0.667,
            "¼": 0.25, "¾": 0.75,
            "⅛": 0.125, "⅜": 0.375, "⅝": 0.625, "⅞": 0.875
        ]
        var result = 0.0
        var integerPart = ""
        for char in raw {
            if let frac = fractionMap[char] {
                result += frac
            } else if char.isNumber {
                integerPart.append(char)
            }
        }
        if let whole = Double(integerPart) {
            result += whole
        }
        return result == 0 ? 1 : result
    }
}
