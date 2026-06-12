# Gradle 9 repro: private members inaccessible in closures

Minimal reproductions of the patterns in `lib/*.gradle` that may break under
Gradle 9 (Groovy 4), per the [upgrade guide](https://docs.gradle.org/current/userguide/upgrading_major_version_9.html#private_properties_and_methods_may_be_inaccessible_in_closures).

| Case | Pattern | Mirrors |
|------|---------|---------|
| A1 | Task class: closure → public method → private method (plain body call) | `lib/java-javadoc.gradle` `downloadListFile` |
| A2 | Task class: closure calls private method directly | (documented breakage, control case) |
| B  | Applied script: `self.privateMethod()` / unqualified call from `afterEvaluate {}` | `lib/java-shade.gradle:53,117,326` |
| C  | Applied script: private method called from `rootProject.ext {}` block | `lib/common-git.gradle:6,10` |

Run all cases (uses `gradle` on PATH by default; pass a path to test another version):

```sh
./run.sh
./run.sh /path/to/gradle-8.x/bin/gradle   # compare against Gradle 8
```
