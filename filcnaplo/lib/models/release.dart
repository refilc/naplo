class Release {
  String tag;
  Version version;
  String author;
  String body;
  List<String> downloads;
  bool prerelease;

  Release({
    required this.tag,
    required this.author,
    required this.body,
    required this.downloads,
    required this.prerelease,
    required this.version,
  });

  factory Release.fromJson(Map json) {
    return Release(
      tag: json["tag_name"] ?? Version.zero.toString(),
      author: json["author"] != null ? json["author"]["login"] ?? "" : "",
      body: json["body"] ?? "",
      downloads: json["assets"] != null ? json["assets"].map((a) => a["browser_download_url"] ?? "").toList().cast<String>() : [],
      prerelease: json["prerelease"] ?? false,
      version: Version.fromString(json["tag_name"] ?? ""),
    );
  }
}

class Version {
  final int major;
  final int minor;
  final int patch;
  final String prerelease;
  final int prever;

  const Version(this.major, this.minor, this.patch, {this.prerelease = "", this.prever = 0});

  factory Version.fromString(String o) {
    String string = o;
    int x = 0, y = 0, z = 0; // major, minor, patch (1.1.1)
    String pre = ""; // prerelease string (-beta)
    int prev = 0; // prerelease version (.1)

    try {
      // cut build
      string = string.split("+")[0];

      // cut prerelease
      var p = string.split("-");
      string = p[0];
      if (p.length > 1) pre = p[1];

      // prerelease
      p = pre.split(".");

      if (p.length > 1) prev = int.tryParse(p[1]) ?? 0;

      // check for valid prerelease name
      if (p[0] != "") {
        if (prereleases.contains(p[0].toLowerCase().trim())) {
          pre = p[0];
        } else {
          throw "invalid prerelease name: ${p[0]}";
        }
      }

      // core
      p = string.split(".");
      if (p.length != 3) throw "invalid core length: ${p.length}";

      x = int.tryParse(p[0]) ?? 0;
      y = int.tryParse(p[1]) ?? 0;
      z = int.tryParse(p[2]) ?? 0;

      return Version(x, y, z, prerelease: pre, prever: prev);
    } catch (error) {
      // ignore: avoid_print
      print("WARNING: Failed to parse version ($o): $error");
      return Version.zero;
    }
  }

  @override
  bool operator ==(other) {
    if (other is! Version) return false;
    return other.major == major && other.minor == minor && other.patch == patch && other.prei == prei && other.prever == prever;
  }

  int compareTo(Version other) {
    if (other == this) return 0;

    if (major > other.major) {
      return 1;
    } else if (major == other.major) {
      if (minor > other.minor) {
        return 1;
      } else if (minor == other.minor) {
        if (patch > other.patch) {
          return 1;
        } else if (patch == other.patch) {
          if (prei > other.prei) {
            return 1;
          } else if (other.prei == prei) {
            if (prever > other.prever) {
              return 1;
            }
          }
        }
      }
    }

    return -1;
  }

  @override
  String toString() {
    String str = "$major.$minor.$patch";
    if (prerelease != "") str += "-$prerelease";
    if (prever != 0) str += ".$prever";
    return str;
  }

  int get prei {
    if (prerelease != "") return prereleases.indexOf(prerelease);
    return prereleases.length;
  }

  static const zero = Version(0, 0, 0);
  static const List<String> prereleases = ["dev", "pre", "alpha", "beta", "rc", "nightly", "test"];

  @override
  int get hashCode => toString().hashCode;
}
